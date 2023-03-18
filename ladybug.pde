int frame_count = 0;
float villain[][][] = new float[1000][2][2]; // 빌런 정보 여기다 저장. [100마리의][[x, y], [vx, vy]]
boolean [] villain_is_active = new boolean[1000]; // 위의 배열에서 n번째 빌런이 활성화된 빌런인지
float ladybug[][] = new float[2][2]; // [[x, y], [vx, vy]]
boolean over = false; // 게임 오버

boolean respawned_villain_in_this_frame = false; // 악당 리스폰을 한 프레임당 한 마리 넘게 하진 않을 생각
int frames_to_villain_respawn = 3; // 악당 리스폰 속도 조절용. 후반으로 가면 한 프레임당 한 마리씩 리스폰하는 걸로

float villain_radius;
float ladybug_radius;
float villain_normal_speed;

void setup() {
    size(720, 720);
    frameRate(30);
}

void draw() {
    background(128, 255, 128);
    if (frame_count < 150) draw_countdown();
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

void render_villain(float x, float y, float vx, float vy) {

}

void render_ladybug(float x, float y, float vx, float vy) {

}

void iterate_villains() {
    respawned_villain_in_this_frame = false;
    for (int i = 0; i < 1000; i++) {
        if (villain_is_active[i]) { // i번째 악당이 활성 상태면
            villain[i][0][0] += villain[i][1][0]; // villain[i]의 x에 vx를 더함
            villain[i][0][1] += villain[i][1][1]; // villain[i]의 y에 vy를 더함
        }
        if (!villain_is_active[i] || villain_out_of_screen(i) || villain_dead(i)) { // i번째 악당이 비활성 악당이거나, 이번 프레임에 죽거나 화면 밖으로 나간 악당이면
            // 새 악당 리스폰한 때가 됐으면 이 자리에 할당
            if (frames_to_villain_respawn == 0 && !respawned_villain_in_this_frame) {
                respawn_villain(i);
                respawned_villain_in_this_frame = true;
                frames_to_villain_respawn = reset_respawn_countdown();
                villain_is_active[i] = true;
            }
            // 아니면 비활성 상태로 남겨두어, 다음 프레임에선 위치 변경 등의 작업을 하지 않음
            else villain_is_active[i] = false;
        }
    }
}

boolean villain_out_of_screen(int idx) {
    // 학당이 화면으로 나갔는지.
    // 보강 예정
    return (villain[idx][0][1] + villain_radius > 720);
}

boolean villain_dead(int idx) {
    // 아이템 구현 시 항목 추가
    return false;
}

int reset_respawn_countdown() {
    // 리스폰 속도가 점점 빨라지게
    if (frame_count < 1000) return 3;
    if (frame_count < 2000) return 2;
    if (frame_count < 2500) return 1;
    return 0;
}

void respawn_villain(int idx) {
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
