require 'gosu'
require './zorder'
require './settings'

class Tutorial < Gosu::Window
    def initialize()
        super(Settings::WINDOW_WIDTH, Settings::WINDOW_HEIGHT)
        self.caption = Settings::CAPTION

        @background_image = Gosu::Image.new("media/space.png", tileable: true)

        @player = Player.new(Settings::NEW_PLAYER_X, Settings::NEW_PLAYER_Y)

        #Loads and divides an image into an array of equally sized tiles
        @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
        @stars = Settings::STARTING_STARS

        @font = Settings::SCORE_FONT
    end

    #Called 60 times per second by default
    #Should contain the main game logic
    def update
        if Gosu.button_down?(Gosu::KB_LEFT) || Gosu::button_down?(Gosu::GP_LEFT)
            @player.turn_left
        end
        if Gosu.button_down?(Gosu::KB_RIGHT) || Gosu::button_down?(Gosu::GP_RIGHT)
            @player.turn_right
        end
        if Gosu.button_down?(Gosu::KB_UP) || Gosu::button_down?(Gosu::GP_BUTTON_0)
            @player.accelerate
        end
        @player.move
        @player.collect_stars(@stars)
        generate_stars
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
            @stars << Star.new(@star_anim)
        end
    end
end


class Player
    attr_reader :score

    def initialize(x, y)
        @image = Gosu::Image.new("media/starfighter.bmp")
        @beep = Gosu::Sample.new("media/beep.wav")
        @x = x 
        @y = y 
        @vel_x = @vel_y = @angle = Settings::INITIAL_VEL
        @score = 0
    end

    def turn_left
        @angle -= Settings::TURN_SPEED
    end

    def turn_right
        @angle += Settings::TURN_SPEED
    end

    def accelerate
        #Offset calculates the horizontal and vertical distances that comprise a diagonal distance travelled at a given angle and pixel distance
        @vel_x += Gosu.offset_x(@angle, Settings::ACCELERATION)
        @vel_y += Gosu.offset_y(@angle, Settings::ACCELERATION)
    end

    def move
        @x += @vel_x
        @y += @vel_y
        @x %= Settings::WINDOW_WIDTH
        @y %= Settings::WINDOW_HEIGHT

        @vel_x *= Settings::DECELERATION
        @vel_y  *= Settings::DECELERATION
    end

    def draw
        #Draw rot places the center of the image at (x, y), not the upper left corner.
        #The player is drawn at z = 1
        @image.draw_rot(@x, @y, 1, @angle)
    end

    def collect_stars(stars)
        stars.reject! do | star |
            if Gosu.distance(@x, @y, star.x, star.y) < Settings::STAR_COLLECT_DISTANCE
                @score += Settings::STAR_VALUE
                @beep.play
                true
            else
                false
            end
        end
    end

end


class Star
    attr_reader :x, :y

    def initialize(animation)
        @animation = animation
        @color = Gosu::Color::BLACK.dup
        @color.red = generate_color()
        @color.green = generate_color()
        @color.blue = generate_color()
        @x = rand * Settings::WINDOW_WIDTH
        @y = rand * Settings::WINDOW_HEIGHT
    end

    def generate_color
        rand(256 - Settings::COLOR_MIN) + Settings::COLOR_MIN
    end

    def draw
        #Every 100 milliseconds, the next index of the animiation array is accessed
        img = @animation[Gosu.milliseconds / Settings::ANIM_SPEED % @animation.size]
        img.draw(@x - (img.width / 2.0), @y - (img.height / 2.0), ZOrder::STARS, 1, 1, @color, :add)
    end
end

#Show does not return until the window is closed by the user or close() is called
#This is the main loop of the game
Tutorial.new.show()
