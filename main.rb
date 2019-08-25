require 'gosu'
require './zorder'

class Tutorial < Gosu::Window
    def initialize()
        super(640, 480)
        self.caption = "Tutorial Game"

        @background_image = Gosu::Image.new("media/space.png", tileable: true)

        @player = Player.new
        @player.warp(320, 240)

        #Loads and divides an image into an array of equally sized tiles
        @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
        @stars = Array.new
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
        @background_image.draw(0, 0, 0)
        @stars.each { | star | star.draw }
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
        if rand(100) < 4 && @stars.size < 25
            @stars << Star.new(@star_anim)
        end
    end
end


class Player
    def initialize
        @image = Gosu::Image.new("media/starfighter.bmp")
        @x = @y = @vel_x = @vel_y = @angle = 0.0
        @score = 0
    end

    def warp(x, y)
        @x, @y = x, y 
    end

    def turn_left
        @angle -= 4.5
    end

    def turn_right
        @angle += 4.5
    end

    def accelerate
        #Offset calculates the horizontal and vertical distances that comprise a diagonal distance travelled at a given angle and pixel distance
        @vel_x += Gosu.offset_x(@angle, 0.5)
        @vel_y += Gosu.offset_y(@angle, 0.5)
    end

    def move
        @x += @vel_x
        @y += @vel_y
        @x %= 640
        @y %= 480

        @vel_x *= 0.95
        @vel_y  *= 0.95
    end

    def draw
        #Draw rot places the center of the image at (x, y), not the upper left corner.
        #The player is drawn at z = 1
        @image.draw_rot(@x, @y, 1, @angle)
    end

    def score
        @score
    end

    def collect_stars(stars)
        stars.reject! { | star | Gosu.distance(@x, @y, star.x, star.y) < 35 }
    end

end


class Star
    attr_reader :x, :y

    def initialize(animation)
        @animation = animation
        @color = Gosu::Color::BLACK.dup
        @color.red = rand(256 - 40) + 40
        @color.green = rand(256 - 40) + 40
        @color.blue = rand(256 - 40) + 40
        @x = rand * 640
        @y = rand * 480
    end

    def draw
        #Every 100 milliseconds, the next index of the animiation array is accessed
        img = @animation[Gosu.milliseconds / 100 % @animation.size]
        img.draw(@x - (img.width / 2.0), @y - (img.height / 2.0), ZOrder::STARS, 1, 1, @color, :add)
    end
end

#Show does not return until the window is closed by the user or close() is called
#This is the main loop of the game
Tutorial.new.show()
