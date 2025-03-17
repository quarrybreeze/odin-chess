require_relative '../lib/game'

describe Game do
  describe '#initialize' do
    context 'when there is no saved game' do
      before do
        allow(File).to receive(:exist?).with("savedgame.dat").and_return(false)
        allow_any_instance_of(Game).to receive(:gets).and_return("new")
      end

      it 'calls play_game' do
        expect_any_instance_of(Game).to receive(:play_game) 
        Game.new
      end
    end


    context 'when there is a saved game' do
      before do
        allow(File).to receive(:exist?).with("savedgame.dat").and_return(true) 
        allow_any_instance_of(Game).to receive(:gets).and_return("new") 
      end

      it 'calls play_game' do
        expect_any_instance_of(Game).to receive(:play_game)
        Game.new
      end
    end
  end

  # let(:game) do
  #   # Stub all gets calls before creating the game instance
  #   allow_any_instance_of(Game).to receive(:gets).and_return("new")
  #   allow_any_instance_of(Player).to receive(:gets).and_return("white")
  #   Game.new

  #   # Stub player_turn to prevent infinite recursion
  #   allow(game).to receive(:player_turn)

  #   game
  # end

  # before do
  #   # Stub file operations
  #   allow(File).to receive(:exist?).with("savedgame.dat").and_return(false)
  # end

  # describe '#king?' do
  #   context 'when both kings are alive' do
  #     it 'returns false for gameover' do
  #       expect(game.instance_variable_get(:@gameover)).to be false
  #     end
  #   end
  # end

  # describe '#make_move' do
  #   context 'when moving a pawn' do
  #     it 'prevents moving to occupied spaces by friendly pieces' do
  #       allow(game).to receive(:player_turn)
  #       game.make_move('pawn', [1, 1])
  #       expect(game).to have_received(:player_turn)
  #     end
  #   end
  # end

  # describe '#checkmate?' do
  #   context 'when king is not in checkmate' do
  #     it 'returns false' do
  #       expect(game.send(:checkmate?)).to be false
  #     end
  #   end
  # end

  # describe '#check?' do
  #   context 'when king is not in check' do
  #     it 'returns false' do
  #       expect(game.send(:check?)).to be false
  #     end
  #   end
  # end

  # describe '#switch_player' do
  #   it 'rotates the players array' do
  #     original_first_player = game.instance_variable_get(:@players).first
  #     game.send(:switch_player)
  #     new_first_player = game.instance_variable_get(:@players).first
  #     expect(new_first_player).not_to eq(original_first_player)
  #   end
  # end

  # describe '#white_first' do
  #   it 'ensures white player goes first' do
  #     game.send(:white_first)
  #     first_player = game.instance_variable_get(:@players).first
  #     expect(first_player.color).to eq('white')
  #   end
  # end

end
