module Settings
    #################
    #Window settings#
    #################
    WINDOW_WIDTH = 640
    WINDOW_HEIGHT = 480
    CAPTION = "Star Fighter"

    #################
    #Player settings#
    #################
    NEW_PLAYER_X = 320
    NEW_PLAYER_Y = 240
    INITIAL_VEL = 0.0
    TURN_SPEED  = 4.5
    ACCELERATION = 0.5
    DECELERATION = 0.95

    ###############
    #Star settings#
    ###############
    STARTING_STARS = []
    STAR_FREQUENCY = 4
    STAR_LIMIT = 25
    STAR_COLLECT_DISTANCE = 25
    STAR_VALUE = 10
    COLOR_MIN = 40
    ANIM_SPEED = 100



    #############
    #UI Settings#
    #############
    SCORE_FONT = Gosu::Font.new(20)
    SCORE_COLOR = Gosu::Color::YELLOW
    SCORE_X = 10
    SCORE_Y = 10


end