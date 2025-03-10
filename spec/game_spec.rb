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
end
