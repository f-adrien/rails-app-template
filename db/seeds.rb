# frozen_string_literal: true

# Seeds
User.create(first_name: 'François',
            last_name: 'Adrien',
            email: 'francois@doconnect.fr',
            password: '123456',
            password_confirmation: '123456')

Account.create(name: 'DoConnect',
               active: true)

Account.create(name: 'HolaQueTal',
               active: true)

AccountUser.create(account: Account.first,
                   user: User.first,
                   permission_level: 0)

AccountUser.create(account: Account.last,
                   user: User.first,
                   permission_level: 0)
