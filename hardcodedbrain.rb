# classe du cerveau de l'ia
class HardCodedBrain
  # Reader des inputs chosit par l'ia
  attr_reader :press_left_arrow, :press_right_arrow, :press_up_arrow,\
    :press_down_arrow

  # Initialisation de l'ia
  def initialize
    @press_left_arrow = false
    @press_right_arrow = false
    @press_up_arrow = false
    @press_down_arrow = false
  end

  # Fonction de choix des inputs
  def think(x, y, vel_x, vel_y, angle, stars, pf_while_turning)
    # S'il y a des étoiles
    if stars.length > 0 then
      # On récupère l'étoile la plus proche
      star = stars.get_min_representative { |star| star.distance(x, y) }

      # Calcul des coordonées relatives
      star_x_rel = star.x - x
      star_y_rel = star.y - y
      # calcul de l'angle avec l'étoile la plus proche
      star_rel_angle = ((- Math.atan2(star_x_rel, star_y_rel) + Math::PI)\
        * 180.0 / Math::PI)
      # Appel de la fonction de choix des inputs selon l'angle
      react_to_angle(angle, star_rel_angle, pf_while_turning)
    end
  end

  # fonction de choix des inputs selon l'angle
  def react_to_angle(angle, star_angle, pf_while_turning)
    # Tolérance
    angle_tolerance = 4.5
    # Différence des angles
    diff_angle = (star_angle - angle) % 360.0

    # Si on va dans la bonne direction, on fonce
    if diff_angle < angle_tolerance && diff_angle > -angle_tolerance then
      @press_up_arrow = true
      @press_left_arrow = false
      @press_right_arrow = false
    # Sinon on tourne
    elsif diff_angle <= 180 then
      @press_up_arrow = pf_while_turning
      @press_left_arrow = false
      @press_right_arrow = true
    elsif diff_angle > 180 then
      @press_up_arrow = pf_while_turning
      @press_left_arrow = true
      @press_right_arrow = false
    end
  end

end
