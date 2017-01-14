# Crossover Tickets

## System prerequisites and dependencies

Here you can find the dependencies for running the project both with or without docker. The recommended way of doing it is with Docker, because all you need is `docker-compose` installed and run `docker-compose up` to run the system or `docker-compose down` to finish it.

### Running with Docker (recommended)
  * You should have `docker` at least version `1.12` installed
  * You should have `docker-compose` at least version `1.8` installed
  * To start the service run `docker-compose up`

### Running without Docker

#### Rails
  * Version `5.0.1` must be installed
  * `mysql2` must be installed
    - You can install it by running `gem install mysql2`

#### Node.js
  * Version `6.3.x` must be installed
  * `npm` package `phantomjs` must be installed

#### MySQL
  * You should have a `MySQL` instance at least version `14.14` running locally

### Generating Documentation from in-code documentation

#### Backend
You will be using `yard` to generate them by going to directory `Code/backend` and running the following command:
```
bundle exec yard doc 'app/**/*.rb' 'lib/**/*.rb'
```

### Generating PNG Diagrams (with Docker images)

#### Mermaid
```
docker run --rm -v (pwd):/data arnau/mermaid mermaid -p diagram_file
```

#### PlantUML
```
cat diagram | docker run -i --rm think/plantuml -tpn > diagram.png
```


## Database initialization
  TODO

## Issues faced while completing the assignment
  TODO

## Feedback
