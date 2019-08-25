module Player
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
end