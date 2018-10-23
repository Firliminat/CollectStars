# Classe du joueur
class Player
  # Constantes liées à la vitesse dé deplacement
  VLIM = 5.0
  ACCEL = 0.5
  DECEL = 0.25

  # Reader de l'attribut angle
  attr_reader :angle

  # Initialisation du joueur
  def initialize(is_human, pf_while_turning)
    # Image et son de collection des étoiles
    @image = Gosu::Image.new("media/starfighter.bmp")
    @beep = Gosu::Sample.new("media/beep.wav")

    # Initialisation du "cerveau" de l'IA
    @brain = HardCodedBrain.new()

    # Initialisation de la vitesse et la position
    # de l'angle de rotation, de l'accélération et du nb d'étoiles collectées
    @x = @y = @vel_x = @vel_y = @angle = 0.0
    @nb_stars = 0
    @accel = 0.0

    # Initialisation du statut de l'ia
    @is_human = is_human
    @pf_while_turning = pf_while_turning
  end

  # Fonction de téléportation
  def warp(x, y)
    @x, @y = x, y
  end

  # Tourner à gauche
  def turn_left
    @angle = (@angle - 4.5) % 360.0
  end

  # Tourner à droite
  def turn_right
    @angle = (@angle + 4.5) % 360.0
  end

  # Accélérer
  def go_forward
    @vel_x += Gosu.offset_x(@angle, ACCEL)
    @vel_y += Gosu.offset_y(@angle, ACCEL)
    @accel = ACCEL
  end

  # Ralentir
  def go_backward
    @vel_x -= Gosu.offset_x(@angle, DECEL)
    @vel_y -= Gosu.offset_y(@angle, DECEL)
    @accel = ACCEL
  end

  # Fonction de gestion de sinputs relatifs aux options de l'IA
  def settings_control
    if Gosu.button_down? Gosu::KB_F1
      @is_human = false
    end
    if Gosu.button_down? Gosu::KB_F2
      @is_human = true
    end
    if Gosu.button_down? Gosu::KB_F3
      @pf_while_turning = false
    end
    if Gosu.button_down? Gosu::KB_F4
      @pf_while_turning = true
    end
  end

  # Contrôle du joueur et de l'IA
  def control(stars)
    if @is_human then
      if Gosu.button_down? Gosu::KB_LEFT or Gosu::button_down? Gosu::GP_LEFT
        turn_left
      end
      if Gosu.button_down? Gosu::KB_RIGHT or Gosu::button_down? Gosu::GP_RIGHT
        turn_right
      end
      if Gosu.button_down? Gosu::KB_UP or Gosu::button_down? Gosu::GP_BUTTON_0
        go_forward
      end
      if Gosu.button_down? Gosu::KB_DOWN or Gosu::button_down? Gosu::GP_BUTTON_1
        go_backward
      end
    else
      @brain.think(@x, @y, @vel_x, @vel_y, @angle, stars, @pf_while_turning)
      if @brain.press_left_arrow
        turn_left
      end
      if @brain.press_right_arrow
        turn_right
      end
      if @brain.press_up_arrow
        go_forward
      end
      if @brain.press_down_arrow
        go_backward
      end
    end
  end

  # Déplacement du joueur
  def move
    # Calcul de la nouvelle position.
    @x += @vel_x
    @y += @vel_y
    @x = [[@x, 0.0].max, 640.0].min
    @y = [[@y, 0.0].max, 480.0].min

    # Calcul de la nouvelle vitesse.
    slow_down_ratio = VLIM / (@accel + VLIM)
    @vel_x *= slow_down_ratio
    @vel_y *= slow_down_ratio

    # Si la vitesse est suffisemment faible on la suppose nulle.
    @vel_x = 0 if @vel_x.abs < 0.0001
    @vel_y = 0 if @vel_y.abs < 0.0001
  end

  # Fonction d'affichage du joueur
  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end

  # Calcul du score
  def score(stars)
    # Calcul du score lié à la distance à l'étoile la plus proche
    star_min_dist = stars.get_min_value { |star| star.distance(@x, @y) }
    max_dist = Math::hypot(640, 480)
    dist_score = 10.0 * (max_dist - star_min_dist) / (max_dist - 34.0)

    # retour du score total
    return @nb_stars * 10.0 + dist_score
  end

  # Accesseur à l'attribut calculé speed
  def speed
    return Math::hypot(@vel_x, @vel_y)
  end

  # Fonction de collection des étoiles
  def collect_stars(stars)
    # reject! update l'array en enlevant tous les objets pour lesquels le bloc
    # d'éxecution suivant la fonction renvoit true
    # ici si une étoile est suffisemment proche du joueur on joue un son,
    # l'enlève de l'array, et on incrémente le nb d'étoiles collectées.
    stars.reject! do |star|
      if star.distance(@x, @y) < 35.0
        @nb_stars += 1
        @beep.play
        true
      else
        false
      end
    end
  end

end
