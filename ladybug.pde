int frame_count = 0;
float villain[][][] = new float[100][2][2]; // [100마리의][[x, y], [vx, vy]]
int villain_count = 0; // 위의 array에서 몇 번째까지가 실제로 유효한 악당인가
float ladybug[][] = new float[2][2]; // [[x, y], [vx, vy]]
boolean over = false;


float villain_radius;
float ladybug_radius;
float villain_normal_speed;

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

void initialize() {

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

void iterate_villains() {
    for (int i = 0; i < villain_count; i++) {
        villain[i][0][0] += villain[i][1][0]; // villain[i]의 x에 vx를 더함
        villain[i][0][1] += villain[i][1][1]; // villain[i]의 y에 vy를 더함

        if (villain_out_of_screen(i) || villain_dead(i)) { // 죽거나 화면 밖으로 나간 악당은
            // 배열에서의 그 자리를 리셋(악당 리스폰)
            reset_villain(i);
        }
    }
}

boolean villain_out_of_screen(int idx) {
    return (villain[idx][0][1] + villain_radius > 720);
}

boolean villain_dead(int idx) {
    // 미구현
    return false;
}

void reset_villain(int idx) {
    int spawn_at_ceilling = int(random(0.9, 2));

    // 스폰 위치 결정
    if (spawn_at_ceilling == 1) {
        villain[idx][0][0] = random(-villain_radius, 720 + villain_radius);
        villain[idx][0][1] = - random(villain_radius, 20);
    }
    else {
        villain[idx][0][0] = random(villain_radius, 20);
        villain[idx][0][0] *= 1 - 2 * int(random(0, 2));
        villain[idx][0][1] = random(-villain_radius, 720 + villain_radius);
    }

    // 속도 벡터가 무당벌레를 향하게
    villain[idx][1][0] = ladybug[0][0] - villain[idx][0][0];
    villain[idx][1][1] = ladybug[0][1] - villain[idx][0][1];
    
    // 속도 벡터 정규화
    float speed = sqrt(villain[idx][1][0] * villain[idx][1][0] + villain[idx][1][1] * villain[idx][1][1]);
    villain[idx][1][0] /= speed;
    villain[idx][1][1] /= speed;

    villain[idx][1][0] *= villain_normal_speed + randomGaussian() * 0.1;
    villain[idx][1][1] *= villain_normal_speed + randomGaussian() * 0.1;
}
