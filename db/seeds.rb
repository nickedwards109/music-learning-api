require 'faker'
include Faker

# Create Users
  # The password 'asdf' is easy to enter during development and testing.

  # Create a single admin with predictable login info
  User.create(
    role: :admin,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: 'admin@example.com',
    password: 'asdf',
    password_confirmation: 'asdf'
  )

  # Create a teacher with predictable login info
  User.create(
    role: :teacher,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: 'teacher@example.com',
    password: 'asdf',
    password_confirmation: 'asdf'
  )

  # Create several random teachers
  3.times do
    User.create(
      role: :teacher,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: 'asdf',
      password_confirmation: 'asdf'
    )
  end

  # Create a student with predictable login info
  User.create(
    role: :student,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: 'student@example.com',
    password: 'asdf',
    password_confirmation: 'asdf'
  )

  # Create several random students
  10.times do
    User.create(
      role: :student,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: 'asdf',
      password_confirmation: 'asdf'
    )
  end

# Create Lessons
  5.times do
    Lesson.create({
      title: Faker::Lorem.sentence(word_count: 3),
      text: Faker::Lorem.paragraph(sentence_count: 10),
      assets_attributes: [
        {
          storageURL:
            "#{Faker::Internet.domain_name(domain: 'example')}/
             #{Faker::Lorem.word}
             .wmv"
        }
      ]
    })
  end
