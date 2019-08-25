require 'gosu'
require './zorder'
require './settings'
require './player'
require './star'

class Tutorial < Gosu::Window
    def initialize()
        super(Settings::WINDOW_WIDTH, Settings::WINDOW_HEIGHT)
        self.caption = Settings::CAPTION

        @background_image = Gosu::Image.new("media/space.png", tileable: true)

        @player = Player::Player.new(Settings::NEW_PLAYER_X, Settings::NEW_PLAYER_Y)

        #Loads and divides an image into an array of equally sized tiles
        #@star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
        @stars = Settings::STARTING_STARS

        @font = Settings::SCORE_FONT
    end

    #Called 60 times per second by default
    #Should contain the main game logic
    def update
        generate_stars
        check_input
        @player.move
        @player.collect_stars(@stars)
    end

    #Called 60 times per second by default. May be skipped for performance reasons
    #Should contain code to redraw the scene, but no game logic
    def draw
        @player.draw
        #Image is drawn at (0, 0). Third argument is z-position.
        @background_image.draw(0, 0, ZOrder::BACKGROUND)
        @stars.each { | star | star.draw }
        @font.draw("Score: #{@player.score}", Settings::SCORE_X, Settings::SCORE_Y, ZOrder::UI, 1.0, 1.0, Settings::SCORE_COLOR)
    end

    def check_input
        if Gosu.button_down?(Gosu::KB_LEFT) || Gosu::button_down?(Gosu::GP_LEFT)
            @player.turn_left
        end
        if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu::button_down?(Gosu::GP_RIGHT)
            @player.turn_right
        end
        if Gosu.button_down?(Gosu::KB_UP) || Gosu::button_down?(Gosu::GP_BUTTON_0)
            @player.accelerate
        end
    end

    def button_down(id)
        if id == Gosu::KB_ESCAPE
            close
        else
            #The Window member function button_down(id) contains default keybindings for window control that we want to keep, hence super mops up any bindings not explicitly covered by button_down.
            super
        end
    end

    def generate_stars
        if rand(100) < Settings::STAR_FREQUENCY && @stars.size < Settings::STAR_LIMIT
            @stars << Star.new
        end
    end
    
end




#Show does not return until the window is closed by the user or close() is called
#This is the main loop of the game
Tutorial.new.show()
