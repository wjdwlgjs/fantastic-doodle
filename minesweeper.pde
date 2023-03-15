boolean[][] mine = new boolean[16][16]; // true if the corresponding cell has a mine in it
boolean[][] flagged = new boolean[16][16]; // true if the cell is flagged. flagged cells can't be opened
boolean[][] opened = new boolean[16][16]; // true if the cell is open. 
int[][] count = new int[16][16]; // count of mines near the cell. 0~8
boolean[][] visited = new boolean[16][16]; // for dfs algorithm
int[][] last_clicked = new int[16][16]; // to detect double click
int frame_after_start;
boolean last_click_was_left;

void setup() {
    size(720, 720);
    initialize();
}

void draw() {
    background(128, 128, 128);
    for (int i=0; i<16; i++) {
        for (int j=0; j<16; j++) {
            render_cell(i, j);
        }
    }
}

void mousePressed() {
    if (mouseButton == LEFT) {
        last_click_was_left = true;
    }
    else {
        last_click_was_left = false;
    }
}

void mouseReleased() {
    int row = mousey_to_row();
    int col = mousex_to_col();
    if (frame_after_start - last_clicked[mousey_to_row][mousex_to_col] < 6) {
        doubleclick(row, col);
        return;
    }
    if (last_click_was_left) {
        leftclick(row, col);
    }
    else {
        rightclick(row, col);
    }
}

void initialize() {
    for (int i=0; i<16; i++) {
        for (int j=0; j<16; j++) {
            mine[i][j] = false;
            flagged[i][j] = false;
            opened[i][j] = false;
            count[i][j] = 0;
            visited[i][j] = false;
            last_clicked[i][j] = 0;
        }
    }
    frame_after_start = 0;
}

void leftclick(int row, int col) {
    
}

void rightclick(int row, int col) {

}

void doubleclick(int row, int col) {

}

void render_cell(int row, int col) {

}

int mousex_to_col() {
    return 0;
}

int mousey_to_row() {
    return 0;
}
