# load_data.py
# run in the debug console pd.set_option('display.max_columns', None)
#!pip install scikit-surprise
import sys
import json
import pandas as pd
import numpy as np
from surprise import Dataset
from surprise import Reader
from surprise import BaselineOnly
from surprise import NormalPredictor
from surprise import SVD
from surprise.model_selection import GridSearchCV
from surprise.model_selection import cross_validate
from collections import defaultdict
# This is to add in the non-taken classes
#from sklearn.utils.extmath import cartesian
from sqlalchemy import create_engine
import pymysql

## Inputs
this_student = int(sys.argv[1])
this_level = sys.argv[2]
# this_student = 101179
# this_level = "UG"
db_host = sys.argv[3]
db_port = int(sys.argv[4])
db_user = sys.argv[5]
db_pw = sys.argv[6]
db_name = "courseRecommender"

## Levers
num_to_return = 20
exclude_special = False
exclude_independent = True
exclude_doctoral = True

db = pymysql.connect(host=db_host,user=db_user,passwd=db_pw, port=db_port, db=db_name)
# cursor = db.cursor()
# query = ("SHOW DATABASES")
# cursor.execute(query)
# for r in cursor:
#     print(r)

#df = pd.read_csv("/content/drive/My Drive/Course Recommender/data/cleaned_data/taken_course_c.csv")
#df = pd.read_csv("data/cleaned_data/taken_course_c.csv")
df = pd.read_sql('SELECT * FROM taken_course', con=db)
#grade_key = pd.read_csv("/content/drive/My Drive/Course Recommender/data/cleaned_data/grade_c.csv")
#grade_key = pd.read_csv("data/cleaned_data/grade_c.csv")
grade_key = pd.read_sql('SELECT * FROM grade', con=db)
#course_key = pd.read_csv("/content/drive/My Drive/Course Recommender/data/cleaned_data/course_c.csv")
#course_key = pd.read_csv("data/cleaned_data/course_c.csv")
course_key = pd.read_sql('SELECT * FROM course', con=db)

course_ix = course_key.drop_duplicates(subset="name").reset_index(drop=True).reset_index(drop=False).rename(columns={"index":"course_index"})[["name","course_index"]]
course_key = course_key.merge(course_ix, on="name", how="left")
# print(df.shape)

# Remove grades we are not interested in.
df = df[df["grade_code"].str.startswith(('A','B','C','D','F')) & ~df["grade_code"].str.startswith('DNG')]
# Add Grade as Quality Points
df = df.merge(grade_key[["grade_code","quality_points"]], how="left", on="grade_code")
# Add course_index to use in place of the unreliable course_id
df = df.merge(course_key[["course_id","course_index"]], how="left", on="course_id")
# Remove missing course_index for courses not found in the course_c table.
## Report Missing Course IDs
#df[df.course_index.isnull()][["course_id"]].drop_duplicates().to_csv("/content/drive/My Drive/Course Recommender/data/cleaned_data/Missing Course IDs from Courses Table.csv")
df = df.dropna(subset=["course_index"])
# Arrange by grade and remove duplicates based on student_id and course_index
df = df.sort_values("grade_code").drop_duplicates(subset=("student_id","course_index"))
# For safety's sake let's reset the index
df.reset_index(drop=True, inplace=True)

# Table of not taken combinations
# unique_students = np.unique(df.student_id)
# unique_course_index = np.unique(df.course_index)
# df_not_taken = pd.DataFrame(cartesian((unique_students, unique_course_index)), columns=("student_id","course_index"))
# df_not_taken["rating"] = 0 

# Check for missing data. 
# Column; number of missing values
# print("## Check for missing data.")
# print(df.isnull().sum())

# Feedback metrics
num_students_average_grade = df.groupby('course_id').agg({'quality_points': 'mean', 'course_id': 'count'}).rename(columns={"course_id":"num_students", "quality_points":"average_grade"}).reset_index()

# Option 1: Use Grades as Rating
df_grades = pd.DataFrame.copy(df)
df_grades["rating"] = df_grades["quality_points"]

# Option 2: Use Taken 1/0 as Rating
df_taken = pd.DataFrame.copy(df)
df_taken["rating"] = 1


## Build Data Object
# Load the data set into Surprise

reader_taken = Reader(rating_scale=(0,1))
data_taken = Dataset.load_from_df(df_taken[['student_id', 'course_index', 'rating']], reader_taken)

reader_grades = Reader(rating_scale=(0.0,4.0))
data_grades = Dataset.load_from_df(df_grades[['student_id', 'course_index', 'rating']], reader_grades)

## Choosing Data & Adding Arbitrary Student 
data = data_taken

# Function to get Top-n recommendations
def get_top_n(predictions, n=10):
    '''Return the top-N recommendation for each user from a set of predictions.

    Args:
        predictions(list of Prediction objects): The list of predictions, as
            returned by the test method of an algorithm.
        n(int): The number of recommendation to output for each user. Default
            is 10.

    Returns:
    A dict where keys are user (raw) ids and values are lists of tuples:
        [(raw item id, rating estimation), ...] of size n.
    '''

    # First map the predictions to each user.
    top_n = defaultdict(list)
    for uid, iid, true_r, est, _ in predictions:
        top_n[uid].append((iid, est))

    # Then sort the predictions for each user and retrieve the k highest ones.
    for uid, user_ratings in top_n.items():
        user_ratings.sort(key=lambda x: x[1], reverse=True)
        top_n[uid] = user_ratings[:n]

    return top_n

# Normal SVD way to training a data set
#trainset = data.build_full_trainset()
#algo = SVD()
#algo.fit(trainset)

# Procedural approach to optimizing the hyperparameters for SVD
# param_grid = {'n_epochs': [5, 10], 'lr_all': [0.002, 0.005],
#               'reg_all': [0.4, 0.6]}
# gs = GridSearchCV(SVD, param_grid, measures=['rmse', 'mae'], cv=3)
# gs.fit(data)

# def test_error(error_measure):
#     print(error_measure)
#     print(gs.best_score[error_measure])
#     print(gs.best_params[error_measure])

# test_error("rmse")
# test_error("mae")

# Next we use the best_estimator to fit the data:
trainset = data.build_full_trainset()
# algo = gs.best_estimator['rmse']
algo = SVD(n_epochs=10, lr_all=0.005, reg_all=0.6)
algo.fit(trainset)

# Than predict ratings for all pairs (u, i) that are NOT in the training set.
testset = trainset.build_anti_testset()
predictions = algo.test(testset)

# We are going to pull 300 recommendations and then subset
top_n = get_top_n(predictions, n=300)
top_n_df = pd.DataFrame(top_n[this_student], columns=("course_index","score"))

# reverse course_index
recommended_course = course_key.merge(top_n_df, on="course_index", how="inner").sort_values("score", ascending=False)
recommended_course = recommended_course[recommended_course.level_id==this_level]


def remove_course_starting_with(mydf, slug):
    mydf = pd.DataFrame.copy(mydf[~mydf["name"].str.startswith(slug)])
    return(mydf)

if exclude_special:
    recommended_course = remove_course_starting_with(recommended_course, "SPECIAL TOPICS")
if exclude_independent:
    recommended_course = remove_course_starting_with(recommended_course, "INDEPENDENT STUDY")
if exclude_doctoral:
    recommended_course = remove_course_starting_with(recommended_course, "DOCTORAL SEMINAR")

recommended_course = recommended_course.merge(num_students_average_grade, how='left', on='course_id')
recommended_course = recommended_course.drop_duplicates("name")
recommended_course = recommended_course[~recommended_course.num_students.isnull()]
recommended_course = recommended_course.head(num_to_return)
recommended_course = recommended_course.sort_values('average_grade', ascending=False)
#recommended_json = recommended_course.set_index('course_id').to_json(orient='index')
# recommended_json = recommended_course.set_index('course_id').to_json(r'data/recommendation.json', orient='index')
recommended_json = recommended_course.to_json(orient='records')
# with open('data/recommend.json', 'w', encoding='utf-8') as f:
#     #json.dump(recommended_json, f, ensure_ascii=False, indent=4)
#     json.dump(recommended_json)
# print(recommended_course.shape)
print(recommended_json)

# print("finished")