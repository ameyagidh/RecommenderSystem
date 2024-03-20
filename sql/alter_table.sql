
/* Set autoincrement for student values */

ALTER TABLE `student` MODIFY `student_id` int(10) NOT NULL AUTO_INCREMENT;

/* INSERT into taken_course to remove the invalid grades like the ones that have x and invalid course_ids */

INSERT INTO `taken_course`(
    `course_id`,
    `grade_code`,
    `level_id`,
    `student_id`,
    `term_id`
)
    SELECT
        t1.`course_id`,
        t1.`grade_code`,
        t1.`level_id`,
        t1.`student_id`,
        t1.`term_id`
    FROM
        `temp_taken_course` t1
    INNER JOIN `grade` t2 ON
        t1.`grade_code` = t2.`grade_code`
    INNER JOIN `course` t3 ON
        t1.`course_id` = t3.`course_id`
    INNER JOIN `student` t4 ON
        t1.`student_id` = t4.`student_id`
    GROUP BY
        t1.`course_id`,
        t1.`grade_code`,
        t1.`level_id`,
        t1.`student_id`,
        t1.`term_id`;