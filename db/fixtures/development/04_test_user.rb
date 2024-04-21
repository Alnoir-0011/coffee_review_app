User.seed do |s|
  s.id = 1
  s.email = 'testuser@example.com'
  s.name = 'testuser'
  s.password = 'password'
  s.password_confirmation = 'password'
  s.role = 'admin'
end