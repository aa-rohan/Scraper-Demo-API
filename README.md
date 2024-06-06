# Product Scraper Application - Backend

This is the backend portion of the Product Scraper Application, developed using Ruby on Rails. This application allows users to scrape product details from e-commerce websites (Currently only Daraz and Flipkart are supported) by providing a URL. The scraped data is stored in a PostgreSQL database and can be managed and viewed via a responsive UI. The backend is designed to handle web scraping, data storage, and asynchronous updates using Redis and Sidekiq.

## Features

- **Web Scraping**: Utilizes Nokogiri and Watir for scraping product details such as title, description, price, contact information, size, and category from e-commerce websites.
- **Data-Driven Scraping**: Add CSS selectors to the constants.rb file for a specific website domain for a flexible and configurable scraping process.
- **Background Processing**: Uses Redis and Sidekiq to handle background scraping tasks, ensuring the UI remains responsive. Products that are older than a week are re-fetched and updated asynchronously.
- **Product Management**: Allows users to submit URLs for scraping and view listed products categorized by product type. Features asynchronous search and filtering for enhanced user interaction.
- **Testing**: Comprehensive test coverage using RSpec to ensure critical functionalities work as expected.

## Installation

### Prerequisites

- **Ruby**: Ensure you have Ruby installed (version 3.0.0 recommended).
- **PostgreSQL**: Ensure you have PostgreSQL installed and running.
- **Redis**: Ensure you have Redis installed (version 6 or higher).

### Setup

1. **Clone the repository:**

   ```sh
   git clone https://github.com/aa-rohan/Scraper-Demo-API.git
   cd Scraper-Demo-API
   ```
   
2. **Install Dependencies:**

   ```sh
    bundle install
    ```
   
3. **Setup the database:**

   ```sh
    rails db:create
    rails db:migrate
    ```
   
4. **Setup Redis:**

   ```sh
    redis server
    ```
   
5. **Start Sidekiq:**

   ```sh
    bundle exec sidekiq
    ```
   
6. **Launch Rails:**

   ```sh
    rails s
    ```
   
## Running Tests

RSpec is used for testing. To run the test suite, use the following command:
   
    bundle exec rspec

## Usage

Currently, support exists for Daraz and Flipkart. More sites can be added by modifying the constants.rb file with your ecommerce website of choice in the specified format.
   
## Next Steps

With more time, the following could be integrated:

- **Enhance Scraping Logic**: Improve the scraping logic to handle more complex websites and dynamic content.
- **Auth**: Use Devise for creating a authentication system so users can have their own product views.
