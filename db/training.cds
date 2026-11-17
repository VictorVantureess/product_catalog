namespace com.training;

entity Course {
  key ID    : UUID;
  Title     : String;
  Credits   : Integer;
  Students  : Association to many StudentCourse on Students.Course = $self;
}

entity Student {
  key ID      : UUID;
  FirstName : String;
  LastName  : String;
  Email     : String;
  Courses   : Association to many StudentCourse on Courses.Student = $self;
}

entity StudentCourse {
  key ID     : UUID;
  Student    : Association to Student;
  Course     : Association to Course;
}