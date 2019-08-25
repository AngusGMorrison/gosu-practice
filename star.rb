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