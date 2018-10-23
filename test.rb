require 'gosu'
require_relative 'array'
require_relative 'hardcodedbrain'
require_relative 'player'
require_relative 'star'

# Module de gestion de la profondeur d'affichage.
module ZOrder
  BACKGROUND, STARS, PLAYER, UI = *0..3
end

# Création de la classe du jeu.
class CollectStars < Gosu::Window
  # Méthode d'initialisation.
  # Set up la talle de la fenêtre, le titre, l'image de fond, ...
  def initialize
    super 640, 480
    self.caption = "Collect Stars"

    @background_image = Gosu::Image.new("media/space.png", :tileable => true)

    # Création du joueur
    @player = Player.new(true, false)
    # On le met au centre de la fenêtre
    @player.warp(320, 240)

    # Set up de l'array des étoiles et de l'aimation des étoiles
    @star_anim = Gosu::Image.load_tiles("media/star.png", 25, 25)
    @stars = Array.new

    #Set up de la police d'affichage
    @font = Gosu::Font.new(20)
  end

  # La fonction est appelée en boucle.
  # C'est là qu'on définit ce que le jeu doit faire à chaque boucle.
  def update
    # Fonction des controles gérant les options
    @player.settings_control
    # Fonction des controles
    @player.control(@stars)
    # Déplacement du joueur
    @player.move
    # On vérifie si des étoiles sont à collecter.
    @player.collect_stars(@stars)

    # Ajout d'étoiles : hasard, sauf si 0 étoiles.
    if (rand(100) < 2 && @stars.size < 15) || @stars.size < 1
      @stars.push(Star.new(@star_anim))
    end
  end

  # Fonction d'affichage.
  def draw
    # Image de fond
    @background_image.draw(0, 0, ZOrder::BACKGROUND)
    # Joueur
    @player.draw
    # Etoiles
    @stars.each { |star| star.draw }

    # Score et infos
    @font.draw("Score: #{@player.score(@stars)}", 10, 10, ZOrder::UI, 1.0, 1.0,\
      Gosu::Color::YELLOW)
    @font.draw("Speed: #{@player.speed}", 10, 25, ZOrder::UI, 1.0, 1.0,\
      Gosu::Color::YELLOW)
    @font.draw("Angle: #{@player.angle}", 10, 40, ZOrder::UI, 1.0, 1.0,\
      Gosu::Color::YELLOW)
  end

  # Fermer la fenêtre.
  def button_down(id)
    if id == Gosu::KB_ESCAPE
      close
    else
      super
    end
  end

end

# Création de la fenêtre de jeu.
CollectStars.new.show
