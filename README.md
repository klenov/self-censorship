# self-censorship
A small utility useful for replacing sensitive data: passwords, emails, secret keys etc.

It's always a good idea not to check sensitive data, such as a password or SSH key into a Git repository. But sometimes it's not easy to separate code and configuration. This utility provides
a way to keep sensitive data in separate files that could be ignored by Git.

## Usage
The configuration file contains file paths and a pairs of fake_data/real_data keys. Every occurrence of fake_data key will be replaced with real_data key.
```ruby
-
  path: ./example_files/test.txt
  passwords:
    - 
       fake_data: fake_password_1
       real_data: cbCDC1Jyc@Y@
    -
       fake_data: fake_password_2
       real_data: $%"'"c#C@^D\1*&Jy?c@Y@,<.>{}""
    -
       fake_data: fake_password_3
       real_data: <%= ENV['REAL_PASSWORD_2'] %>
```

It's also possible to store key values in an environmental variables.
```shell
REAL_PASSWORD_2=some-secret ruby main.rb 
```
