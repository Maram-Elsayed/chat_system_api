Chat System API

Overview

This project implements a chat system API using Ruby on Rails, MySQL, and ElasticSearch. The system supports creating applications, chats, and messages, and allows searching messages using ElasticSearch. The application is containerized with Docker.




Features

- Applications: Create and manage applications with a unique token and name.

- Chats: Each application can have multiple chats. Chats are numbered uniquely within an application starting from 1.

- Messages: Each chat can have multiple messages, numbered uniquely within a chat starting from 1.

- Search: Search messages within a chat using partial matching with ElasticSearch.

- Concurrency: Handles race conditions and uses a queuing system for chat and message creation.

- Data Sync: Ensures chats_count and messages_count are updated within 1 hour.



Getting Started

  Prerequisites
  
    1. Docker: Ensure Docker is installed on your machine. You can download it from Docker's official website.
    
    2. Docker Compose: Ensure Docker Compose is installed. You can download it from Docker Compose's official website.
    
    3. MySQL: This application requires MySQL as the primary database. The Docker Compose configuration sets up MySQL automatically, but ensure the following environment variable is set correctly in the docker-compose.yml:
    MYSQL_ROOT_PASSWORD=password


    
