User.create_with(password: "secret", name: "Admin", is_admin: true).find_or_create_by!(email: "admin@ecommerce.com")
User.create_with(password: "secret", name: "Customer", is_admin: false).find_or_create_by!(email: "customer@ecommerce.com")
User.create_with(password: "secret", name: "Another", is_admin: false).find_or_create_by!(email: "client@ecommerce.com")
