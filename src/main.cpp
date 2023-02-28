#include <SFML/Graphics.hpp>
#include <iostream>
using namespace std;

const int SCREEN_WIDTH = 600;
const int SCREEN_HEIGHT = 600;
const int BOARD_SIZE = 3;
const int SQUARE_SIZE = 200;

enum class Player {
    None,
    X,
    O
};

class Game {
public:
    Game() {
        // Set up the game board
        for (int i = 0; i < BOARD_SIZE; ++i) {
            for (int j = 0; j < BOARD_SIZE; ++j) {
                board[i][j] = Player::None;
            }
        }
        // Set up the window
        window.create(sf::VideoMode(SCREEN_WIDTH, SCREEN_HEIGHT), "Tic Tac Toe");
        window.setFramerateLimit(60);
        // Set up the font
        font.loadFromFile("res/font/Anglican.ttf");
        xTexture.loadFromFile("res/sprites/x.png");
        xTexture.setSmooth(true);
        oTexture.loadFromFile("res/sprites/o.png");
        oTexture.setSmooth(true);
        // Set up the text
        text.setFont(font);
        text.setCharacterSize(100);
        text.setFillColor(sf::Color::Green);
        text.setStyle(sf::Text::Bold);
    }

    void run() {
        while (window.isOpen()) {
            handleEvents();
            update();
            render();
        }
    }

private:
    void handleEvents() {
        sf::Event event;
        while (window.pollEvent(event)) {
            switch (event.type) {
            case sf::Event::Closed:
                window.close();
                break;
            case sf::Event::MouseButtonPressed:
                if (event.mouseButton.button == sf::Mouse::Left) {
                    handleClick(event.mouseButton.x, event.mouseButton.y);
                }
                break;
            default:
                break;
            }
        }
    }

    void handleClick(int x, int y) {
        if (winner != Player::None) {
            // If there is already a winner, ignore clicks
            return;
        }
        int row = y / SQUARE_SIZE;
        int col = x / SQUARE_SIZE;
        if (row < 0 || row >= BOARD_SIZE || col < 0 || col >= BOARD_SIZE) {
            // If the click is outside the board, ignore it
            return;
        }
        if (board[row][col] != Player::None) {
            // If the square is already taken, ignore the click
            return;
        }
        board[row][col] = currentPlayer;
        currentPlayer = (currentPlayer == Player::X) ? Player::O : Player::X;
        checkForWinner();
    }

    void checkForWinner() {
        // Check rows
        for (int i = 0; i < BOARD_SIZE; ++i) {
            if (board[i][0] != Player::None && board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
                winner = board[i][0];
                return;
            }
        }
        // Check columns
        for (int j = 0; j < BOARD_SIZE; ++j) {
            if (board[0][j] != Player::None && board[0][j] == board[1][j] && board[1][j] == board[2][j]) {
                winner = board[0][j];
                return;
            }
        }
        // Check diagonals
        if (board[0][0] != Player::None && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
            winner = board[0][0];
            return;
        }
        if (board[0][2] != Player::None && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
        winner = board[0][2];
        return;
    }
}

void update() {
    // Update the text
    switch (winner) {
    case Player::None:
        text.setString("");
        break;
    case Player::X:
        text.setString("X wins!");
        break;
    case Player::O:
        text.setString("O wins!");
        break;
    }
}

void render() {
    // Clear the window
    window.clear(sf::Color::White);
    // Draw the board
    for (int i = 0; i < BOARD_SIZE; ++i) {
        for (int j = 0; j < BOARD_SIZE; ++j) {
            sf::RectangleShape square(sf::Vector2f(SQUARE_SIZE, SQUARE_SIZE));
            square.setOutlineThickness(5);
            square.setOutlineColor(sf::Color::Blue);
            square.setPosition(j * SQUARE_SIZE, i * SQUARE_SIZE);
            switch (board[i][j]) {
            case Player::None:
                break;
            case Player::X:
                square.setTexture(&xTexture);
                break;
            case Player::O:
                square.setTexture(&oTexture);
                break;
            }
            window.draw(square);
        }
    }
    // Draw the text
    text.setPosition(SCREEN_WIDTH / 2 - text.getGlobalBounds().width / 2, SCREEN_HEIGHT / 2 - text.getGlobalBounds().height / 2);
    window.draw(text);
    // Display the window
    window.display();
}
private:
    sf::RenderWindow window;
    sf::Texture xTexture;
    sf::Texture oTexture;
    sf::Font font;
    sf::Text text;
    Player board[BOARD_SIZE][BOARD_SIZE];
    Player currentPlayer = Player::X;
    Player winner = Player::None;

};

int main() {
Game game;
game.run();
return 0;
}