# ajout de fonction aux arrays
class Array

  # Renvoit la valeur minimale selon le bloc d'éxecution suivant la fonction
  def get_min_value(&block)
    min = Float::INFINITY
    min_index = -1
    for i in 0..(size - 1)
      val = yield(self[i])
      if val < min then
        min = val
        min_index = i
      end
    end
    return min
  end

  # Renvoit le 1er représentant de la valeur minimale selon le bloc d'éxecution
  # suivant la fonction
  def get_min_representative(&block)
    min = Float::INFINITY
    min_index = -1
    for i in 0..(size - 1)
      val = yield(self[i])
      if val < min then
        min = val
        min_index = i
      end
    end
    return self[min_index]
  end

end
