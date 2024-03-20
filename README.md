# Course Recommender System

The Course Recommender System is a project aimed at providing personalized course recommendations to students based on their academic background and preferences. By leveraging user profile data and collaborative filtering techniques, the system generates tailored recommendations to assist students in making informed decisions about their course selections.

## Screenshot

<img width="1496" alt="Screenshot 2024-03-20 at 1 27 31 AM" src="https://github.com/ameyagidh/RecommenderSystem/assets/65457905/f381cb9e-c94f-4be5-9352-f2e51e6eb65a">

![ezgif com-animated-gif-maker](https://github.com/ameyagidh/RecommenderSystem/assets/65457905/ff7bb875-1837-44a7-82d5-8237b22dcede)


## Features

- **User Profile Collection**: Collects comprehensive user profiles including demographic information (name, age, gender) and academic details (start term, study plan, level of study, degree, previously taken courses) through HTML forms.
- **Data Preprocessing**: Preprocesses the collected data to handle missing values, standardize formats, and encode categorical variables.
- **Model Training**: Trains a collaborative filtering model using techniques such as matrix factorization or deep learning methods to learn patterns from user profiles and course interactions.
- **Recommendation Generation**: Generates course recommendations for each user based on similar user profiles and previously taken courses. Utilizes techniques like cosine similarity or Euclidean distance for user similarity measurement.
- **Ranking**: Ranks recommended courses based on factors like the number of students who have taken the course and the average grade of those students.
- **Evaluation**: Evaluates the performance of the recommendation system using metrics like precision, recall, and accuracy. Incorporates user feedback to refine the recommendations over time.
- **User Interface**: Provides an intuitive user interface where students can input their profile information and view the recommended courses.
- **Privacy and Security**: Adheres to privacy regulations and guidelines to protect user data and prevent unauthorized access.

## Getting Started

1. **Clone the Repository**:
   ```
   git clone https://github.com/ameyagidh/recommenderSystem.git
   ```

2. **Install Dependencies**:
   ```
   pip install -r requirements.txt
   ```

3. **Run the Application**:
   ```
   python app.py
   ```

4. **Access the User Interface**:
   Open a web browser and navigate to `http://localhost:5000` to access the user interface.

## Contributing

Contributions are welcome! If you'd like to contribute to the project, please follow these steps:

1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Make your changes and commit them (`git commit -am 'Add new feature'`).
4. Push your changes to the branch (`git push origin feature-branch`).
5. Create a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
