# KeskonMange

## Server
### Requirements ✅
- `Redis` (*Redis server v7.0.15*)
- `NodeJS` (*Node v20.13.1*)
- `npm` (*Npm v10.5.2*)
- `MariaDB` (*MariaDB v15.1*)
### Build and run the server
1. Clone the repository
2. Go to the `server/` folder
3. (Need to build a script to create the database)
4. **Define your *environment variables***:
	- DATABASE_HOST: *url of your database*
	- DATABASE_USER: *your DB user*
	- DATABASE_PASSWORD: *password of your DB user*
	- DATABASE_NAME: *the database you want to use*
	- SMTP_HOST: *url of your SMTP server*
	- SMTP_ADDRESS: *email you want to use*
	- SMTP_PASSWORD: *password of the address*
5. **Add optional *environment variables* (to run tests):**
	- POP3_HOST: *url of your POP3 server*
	- POP3_ADDRESS: *email you want to use*
	- POP3_PASSWORD: *password of the address*
6. Run `npm ci` to install all the dependencies
7. Run `npm run start` to launch the server
## Client
### Requirements ✅
- `libsecret` (*Linux only*)
- `Flutter sdk`
- `Dart`
### Build and run client
1. Clone the repository
2. Go to the `client/` folder
3. Run `flutter pub get` to install the dependencies