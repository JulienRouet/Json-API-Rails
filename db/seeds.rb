Article.delete_all
User.delete_all

User.create(email:"a@a.com", password:"123456")
User.create(email:"b@b.fr", password:"123456")

30.times do |x|
    article = Article.create(
    title: Faker::Books::Lovecraft.location,
    content: Faker::Books::Lovecraft.paragraph,
        user: User.first
  )
  puts "Création de l'article n°#{x} "
end

30.times do |x|
    article = Article.create(
    title: Faker::Books::Lovecraft.location,
    content: Faker::Books::Lovecraft.paragraph,
        user: User.last
  )
  puts "Création de l'article n°#{x} "
end