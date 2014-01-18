module Instructions

  card_dumpers = [
    %i(Discard discards),
    %i(Remove  removed),
    %i(Limbo   limbo)
  ]

  # Defines:
  #
  #   class Discard < Instruction
  #   class Remove  < Instruction
  #   class Limbo   < Instruction
  #
  # Discards/Removes/Limbos the specified card, unless it is already in any
  # of the three piles.
  #
  card_dumpers.each do |class_name, card_pile_name|
    klass = Class.new(Instruction) do
      arguments :card_ref

      needs :cards, :discards, :removed, :limbo

      define_method :action do
        card = cards.find_by_ref(card_ref)

        already_disposed = %i(discards removed limbo).any? do |pile|
          send(pile).include?(card)
        end

        send(card_pile_name) << card unless already_disposed
      end
    end

    const_set(class_name, klass)
  end

end
