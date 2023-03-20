int frame_count = 0;
float villain[][][] = new float[1000][2][2]; // 빌런 정보 여기다 저장. [100마리의][[x, y], [vx, vy]]
boolean [] villain_is_active = new boolean[1000]; // 위의 배열에서 n번째 빌런이 활성화된 빌런인지
float ladybug[][] = new float[2][2]; // [[x, y], [vx, vy]]
boolean over = false; // 게임 오버

boolean respawned_villain_in_this_frame = false; // 악당 리스폰을 한 프레임당 한 마리 넘게 하진 않을 생각
int frames_to_villain_respawn = 3; // 악당 리스폰 속도 조절용. 후반으로 가면 한 프레임당 한 마리씩 리스폰하는 걸로

float villain_radius = 20;
float ladybug_radius = 30;
float villain_normal_speed = 2;

void setup() {
    size(720, 720);
    frameRate(30);
    initialize();
}

void draw() {
    background(128, 255, 128);
    /* if (frame_count < 150) draw_countdown();
    else  */if (over) draw_gameover();
    else draw_game();
    frame_count += 1;
    if (frames_to_villain_respawn > 0) frames_to_villain_respawn -= 1;
}

void initialize() {
    ladybug[0][0] = 360;
    ladybug[0][1] = 360;
    for (int i=0; i<1000; i++) {
        villain_is_active[i] = false;
    }
}

void draw_countdown() {
    // 초반 countdown 및 마우스 위치 초기화
    for (int i=1; i<6; i++) {
        if (frame_count < 30 * i && frame_count > 30 * (i-1)) {
            fill(255,0,0);
            textSize(180);
            String count = Integer.toString(6-i);
            text(count,330,300);
        }
    }
}

void draw_game() {
    iterate_villains();
    move_ladybug();
    render_ladybug(ladybug[0][0], ladybug[0][1], ladybug[1][0], ladybug[1][1]);
}

void draw_gameover() {

}

void render_villain(float x, float y, float vx, float vy) {
    float c = villain_radius;
    float angle = atan(vx / vy);
    float eye_x_r = c * (cos(-angle)- sin(-angle)) / 2;
    float eye_x_l = c * (- cos(-angle) - sin(-angle)) / 2;
    float eye_y_r = c * (cos(-angle) + sin(-angle)) / 2;
    float eye_y_l = c * (cos(-angle) - sin(-angle)) / 2;
    fill(255, 0, 0);
    circle(x, y, villain_radius*2);
    fill(255,255,102);
    arc(x+eye_x_r, y+eye_y_r, c*2/3, c*2/3, -PI/4 - angle, PI*3/4 - angle);
    arc(x+eye_x_l, y+eye_y_l, c*2/3, c*2/3, PI/4 - angle, PI*5/4 - angle);
}

void render_ladybug(float x, float y, float vx, float vy) {
    float r = ladybug_radius;
    float angle = atan(vx / vy);
    if (vy <= 0 && vx > 0) angle += PI;
    else if (vx <= 0 && vy < 0) angle += PI;
    else if (vy >= 0 && vx < 0) angle = 2 * PI + angle;

    float _cos = r * cos(-angle);
    float _sin = r * sin(-angle);
    fill(255,249,60);
    circle(x, y, ladybug_radius*2);
    
    fill(255,241,215);
    arc(x,y,r*2,r*2,0-angle, PI-angle);

    line(x-_cos, y - _sin, x + _cos, y + _sin);
    line(x,y,x + _sin,y - _cos);
    
    fill(255);
    circle(x + 0.4 * _cos - 0.5 * _sin, y + 0.5 * _cos + 0.4 * _sin,r*4/5);
    circle(x - 0.4 * _cos - 0.5 * _sin, y + 0.5 * _cos - 0.4 * _sin,r*4/5);
    
    fill(0);
    circle(x + 0.4 * _cos - 2* _sin / 3, y + 2 * _cos/3 + 0.4 * _sin,r/2);
    circle(x - 0.4 * _cos - 2 * _sin / 3, y + 2 * _cos/3 - 0.4 * _sin,r/2);
    
    fill(204,153,102);
    circle(x + 2 * _cos/7 + 0.5 * _sin, y - 0.5 * _cos + 2 * _sin / 7,r*2/5);
    circle(x - 2 * _cos/7 + 0.5 * _sin, y - 0.5 * _cos - 2 * _sin / 7,r*2/5);
    circle(x + 2 * _cos/3 + 2 * _sin/7, y - 2 * _cos/7 + 2 * _sin / 3,r*2/7);
    circle(x - 2 * _cos/3 + 2 * _sin/7, y - 2 * _cos/7 - 2 * _sin / 3,r*2/7);
}

void move_ladybug() {
    ladybug[1][0] = (mouseX - 360) * 0.03;
    ladybug[1][1] = (mouseY - 360) * 0.03;
    ladybug[0][0] += ladybug[1][0];
    ladybug[0][1] += ladybug[1][1];

    if (ladybug[0][0] < ladybug_radius) ladybug[0][0] = ladybug_radius;
    if (ladybug[0][1] < ladybug_radius) ladybug[0][1] = ladybug_radius;
    if (ladybug[0][0] + ladybug_radius > 720) ladybug[0][0] = 720 - ladybug_radius;
    if (ladybug[0][1] + ladybug_radius > 720) ladybug[0][1] = 720 - ladybug_radius;
}

void iterate_villains() {
    respawned_villain_in_this_frame = false;
    for (int i = 0; i < 1000; i++) {
        if (villain_is_active[i]) { // i번째 악당이 활성 상태면
            villain[i][0][0] += villain[i][1][0]; // villain[i]의 x에 vx를 더함
            villain[i][0][1] += villain[i][1][1]; // villain[i]의 y에 vy를 더함
            render_villain(villain[i][0][0], villain[i][0][1], villain[i][1][0], villain[i][1][1]);
            if (sqrt((ladybug[0][0] - villain[i][0][0]) * (ladybug[0][0] - villain[i][0][0]) + (ladybug[0][1] - villain[i][0][1]) * (ladybug[0][1] - villain[i][0][1])) <= ladybug_radius + villain_radius) over = true;
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
    villain[idx][0][0] = random(-720, 720);
    villain[idx][0][1] = -villain_radius;

    villain[idx][1][0] = ladybug[0][0] - villain[idx][0][0];
    villain[idx][1][1] = ladybug[0][1] - villain[idx][0][1];

    float speed = sqrt(villain[idx][1][0] * villain[idx][1][0] + villain[idx][1][1] * villain[idx][1][1]);
    villain[idx][1][0] /= speed;
    villain[idx][1][1] /= speed;

    villain[idx][1][0] *= villain_normal_speed;
    villain[idx][1][1] *= villain_normal_speed;

}
