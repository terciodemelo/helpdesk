### Frontend as a separated process from backend
One of the requirements was the use of a modern JavaScript framework on the front-end, using latest versions if possible. This hinted to me that I could use a now popular choice of web services architecture: The frontend be a separate process.

Thus, I've chosen `Vue.js` as frontend framework, which was the most popular javascript framework of 2016 and is my personal favorite.
Also, in this architecture, a reverse proxy is used to redirect the appropriated requests to each process

### Multiple intervals for tickets report
The requirement said that it should be possible for Support Agents to be able to generate a PDF report for the closed tickets in the past 30 days. I added more options to this, the Support Agent or Administrator can generate support for all existing tickets, the ones updated in the past 30 days, the ones updated in the past 7 days, and the ones updated in the past 24 hours.

I considered it a good feature that brings more value to the project

## System prerequisites and dependencies

#### Docker
  * You should have `docker` at least version `1.12` installed
  * You should have `docker-compose` at least version `1.8` installed
  * Docker here is used to start an NGINX instance which will proxy pass to the frontend and backend which will be served as two saparated processes. Also, if you want to generate the diagram images you can do
  it through docker as will shown later.

#### Rails
  * Version `5.0.1` must be installed
  * `bundler` must be installeg
    * You can install it by running `gem install bundler`
  * `mysql2` must be installed
    - You can install it by running `gem install mysql2`

#### Node.js
  * Version `6.3.x` must be installed
  * `npm` package `phantomjs` must be installed
  * Node.js is needed because the frontend service is built with Vue.js

#### MySQL
  * You should have a `MySQL` instance at least version `14.14` running locally

### Generating Documentation from in-code documentation

Both backend and frontend services have plenty in-code documentation. The backend in code can also be extrated to HTML by using `yard`

#### Backend
You will be using `yard` to generate them by going to directory `Code/backend` and running the following command:
```
bundle exec yard doc 'app/**/*.rb' 'lib/**/*.rb'
```

### Generating PNG Diagrams (with Docker images)
The UML diagrams for this project were made by making use of PlantUML, you can compile each diagram file with the command below. The diagrams files are located in `Docs/design/plantuml/` directory

#### PlantUML
```
cat diagram | docker run -i --rm think/plantuml -tpn > diagram.png
```

## Preparing the system

### Installing project packages
You must install the dependencies for the frontend and dependencies for the backend, that means:

```
cd Code/backend
bundle install
cd ../frontend
npm install
```

### Database initialization
The Database initialization must be done by using a rake task as shown below, but your current working directory must be `Code/backend/`
```
bundle exec rails db:setup
```

### System start (development environment)
After installing project packages and initializing the database you shall run three commands to start the server, prefebly in three different terminals. After executing them, you will be able to access the service in `localhost:5000`

#### Backend
Notice that it is important to serve it on `0.0.0.0`
```
cd Code/backend
bundle exec rails server -b 0.0.0.0
```

Use `Ctrl-C` to stop

#### Frontend
```
cd Code/frontend
npm run start:dev
```

Use `Ctrl-C` to stop

#### Reverse Proxy
```
cd Code
docker-compose up
```

Use `Ctrl-C` to stop


## Issues faced while completing the assignment
Some minor issues includes the export of the report to PDF, which didn't get as pretty as I would like to. Besides that, there was no big problem.

### Which requirements I didn't covered
* I didn't implement responsive design that easily addapts to any screen size and device, I targeted desktops. I didn't do it just because I didn't have as much free time as I would like to work on this assignment.

## Feedback
I really enjoyed the assignment and had a lot of fun completing it, I don't have anything to complain about it. But I think that one thing that could be in the assignment is the candidate implementing two or three features in the system that they think brings value to the project.
