require_relative '../lib/board'

describe Board do
  let(:board) { Board.new }

  describe '#initialize' do
    it 'creates an 8x8 board' do
      expect(board.tiles.size).to eq(8)
      expect(board.tiles.all? { |col| col.size == 8 }).to be true
    end

    it 'places the pieces correctly' do
      expect(board.tiles[0][0]).to be_a(Rook)
      expect(board.tiles[4][0]).to be_a(King)
      expect(board.tiles[0][7]).to be_a(Rook)
      expect(board.tiles[4][7]).to be_a(King)
    end
  end

  describe '#pick_tile' do
    it 'returns the correct piece or empty tile' do
      expect(board.pick_tile(0, 0)).to be_a(Rook)
      expect(board.pick_tile(3, 3)).to be_a(EmptyTile)
    end
  end

  describe '#move' do
    it 'moves a piece from one tile to another' do
      board.move([0, 1], [0, 3]) # Move white pawn forward
      expect(board.tiles[0][3]).to be_a(Pawn)
      expect(board.tiles[0][1]).to be_a(EmptyTile)
    end
  end
end