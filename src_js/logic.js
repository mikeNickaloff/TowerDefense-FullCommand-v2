Qt.include("core/Grid.js");
Qt.include("finders/AStarFinder.js");
function get_shortest_path(col_1, row_1, col_2, row_2) {

    var grid = new Grid(game.board.colCount, game.board.rowCount);


    var finder = new AStarFinder({ allowDiagonal: false, dontCrossCorners: false });


    var tmp_sq = game.board.squares;
    for (var u=0; u<tmp_sq.length; u++) {
        var squ = tmp_sq[u];
        grid.setWalkableAt(squ.col, squ.row, true);

    }
    var tmp_gu = game.board.guns;
    for (var u=0; u<tmp_gu.length; u++) {
        var gu = tmp_gu[u];
        grid.setWalkableAt(gu.col, gu.row, false);
    }
    grid.setWalkableAt(col_1, row_1, true);
    grid.setWalkableAt(col_2, row_2, true);
    var rv = finder.findPath(col_1, row_1, col_2, row_2, grid);

    return rv;
}
