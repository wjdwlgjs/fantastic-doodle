boolean[][] mine = new boolean[16][16]; // true if the corresponding cell has a mine in it
boolean[][] flagged = new boolean[16][16]; // true if the cell is flagged. flagged cells can't be opened
boolean[][] open = new boolean[16][16]; // true if the cell is open. 
int[][] count = new int[16][16]; // count of mines near the cell. 0~8
boolean[][] visited = new boolean[16][16]; // for dfs algorithm

void setup() {
    size(720, 720);
    
}

void draw() {
    
}

void initialize() {
    for (int i=0; i<16; i++) {
        for (int j=0; j<16; j++) {
            mine[i][j] = false;
            flagged[i][j] = false;
            open[i][j] = false;
            count[i][j] = 0;
            visited[i][j] = false;
        }
    }
}

void open(int row, int col) {

}

