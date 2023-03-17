int frame_count = 0;
float demon = new float[2][100][4]; //[idx][몇번째][x][y][v_x][v_y]
int demon_count = new int[2]; 
float ladybug = new float[4]; //[x][y][v_x][v_y]
boolean over = false;


void setup() {
    size(720, 720);
}

void draw() {
    background(128, 255, 128);
    if (frame_count < 300) draw_countdown();
    else if (over) draw_gameover();
    else draw_game();
    frame_count += 1;
}

void draw_countdown() {
    // 초반 countdown 및 마우스 위치 초기화
}

void draw_game() {

}

void draw_gameover() {

}

void render_demon(float x, float y, float vx, float vy) {

}

void render_ladybug(float x, float y, float vx, float vy) {

}

