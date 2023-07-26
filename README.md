# PokéVerse: The Multilingual Pokémon Database

## Overview
PokéVerse is a comprehensive and multilingual Pokémon database that provides users with information about various Pokémon species. It serves as a valuable resource for Pokémon enthusiasts, gamers, developers, and researchers who require access to accurate and up-to-date Pokémon data.

## Features
- **Extensive Pokémon Data**: PokéVerse includes a vast collection of Pokémon species, each with detailed information such as name, type, abilities, base stats, evolution chain, and more.
- **Multilingual Support**: The database supports multiple languages, allowing users to access Pokémon information in their preferred language. 

Supported Languages: 
 - English 
 - Japanese 
 - French 
 - German 
 - Spanish

## Installation
To set up PokéVerse locally, follow these steps:

1. Ensure that PostgreSQL14 or greater is installed on your system.
2. Clone the repository: `git clone https://github.com/cjand225/pokeverse.git`
3. Run `make create_db` to create and populate the database.
4. Once the database is set up from the makefile, you can proceed with running PokéVerse locally.

Note: Ensure that you have the necessary permissions to create and drop databases in your PostgreSQL environment.

## Unit Testing

PokéVerse uses the pgTAP framework for unit testing its PostgreSQL database. pgTAP is a collection of functions and command-line tools that facilitate writing and executing tests against the database.

To run the unit tests, ensure that pgTAP is installed and available in your PostgreSQL environment. You can install pgTAP using the package manager specific to your operating system or by manually downloading the source code.

Once pgTAP is installed, navigate to the project directory and run the following command to execute the tests:

`pg_prove -d your_database_name -U your_username -h your_host -p your_port tests/*.sql`

Replace your_database_name, your_username, your_host, and your_port with the appropriate values for your PostgreSQL configuration.

The test files are located in the tests directory and have the .sql extension. Review the test results to ensure that all tests pass successfully.

## Contribution
Contributions to PokéVerse are welcome! If you'd like to contribute, please follow these guidelines:
- Fork the repository and create a new branch for your feature or bug fix.
- Commit your changes and create a clear and concise pull request.

## License
PokéVerse is released under the [MIT License](https://opensource.org/licenses/MIT). You are free to use, modify, and distribute this project in accordance with the terms of the license.

## Disclaimer
Pokémon is a registered trademark of The Pokémon Company. All Pokémon-related names, characters, and imagery are the property of The Pokémon Company. The use of Pokémon-related content in this application/service is solely for informational and non-commercial purposes. This application/service is not endorsed, sponsored, or affiliated with The Pokémon Company. The Pokémon Company holds all rights to the Pokémon franchise, including but not limited to copyright and trademark rights.
