static final int W_WINDOW = 750;    //ウィンドウのサイズ
static final int H_WINDOW = 550;    //
static final int W_CELL = 10;   //セルのサイズ
static final int EDIT_MODE = 0; //modeがこの値の時に編集モードにする
static final int ANIMATION_MODE = 1;    //modeがこの値の時にアニメーションモードにする

int fps;    //fps

Cell[][] currentCells, nextCells;

int col, row;   //列、行の数
int mode;   //モード切替用変数
int info;   //情報の表示切替用変数
int generation; //世代を数えるための変数

PFont font;

//初めに実行する部分
void setup() {
    size(W_WINDOW, H_WINDOW);    //ウィンドウサイズを指定
    fps = 10;       //フレームレートのデフォルトは10      
    smooth();

    col = W_WINDOW / W_CELL;    //ウィンドウに収まる分だけ配列を用意
    row = H_WINDOW / W_CELL;
    currentCells = new Cell[col][row];
    nextCells = new Cell[col][row];
    for (int i = 0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j] = new Cell(i*W_CELL, j*W_CELL, W_CELL);
            nextCells[i][j] = new Cell(i*W_CELL, j*W_CELL, W_CELL);
        }
    }

    mode = EDIT_MODE;   //編集モードでスタートする
    generation = 1;     //世代は1から

    font = loadFont("UbuntuMono-Regular-48.vlw");   //フォントのロード
}

//ループ部分 
void draw() {
    frameRate(fps); //フレームレートの設定
    background(0);
    if (mode == ANIMATION_MODE) {   //次世代の生成
        nextGeneration();
        updateCells();
        generation++;   //世代をカウント
    }

    drawField();    //セルの描画

    if (info==1) {    //更新速度と世代の表示
        dispInfo();
    }
}

//クリック時のマウスの位置からセルを特定する
void mouseClicked() {
    if (mode == EDIT_MODE) {
        int locX = mouseX / W_CELL; //マウスの位置
        int locY = mouseY / W_CELL;
        //マウスの位置から特定されたセル
        Cell theCell = currentCells[locX][locY];
        int level = theCell.getLevel(); //セルの生死判定を得る

        //生死の切り替え
        if (level >= 1) {
            theCell.setLevel(0);
        }
        else {
            theCell.setLevel(1);
        }
    }
}

//キーをおした時の動作
void keyPressed() {
    //画面のクリア
    if (key == 'c') clearCell();
    //ランダムに初期化
    if (key == 'r') randomInit();
    //更新速度の操作
    if (key == 'h') fps = 10;
    if (key == 'l') fps = 60;
    if (key == 'k') fps += 2;
    if (key == 'j') {
        fps -= 2;
        if (fps <= 1) fps = 1;
    }
    //編集モードとアニメーションモードの切替
    if (key == ' ') {
        if (mode == ANIMATION_MODE) {
            mode = EDIT_MODE;
        }
        else if (mode == EDIT_MODE) {
            mode = ANIMATION_MODE;
        }
    }
    //情報表示の切替
    if (key == 'i') {
        if ( info == 0) {
            info = 1;
        }
        else if (info == 1) {
            info = 0;
        }
    }
    //銀河を生成
    if (key == '1') galaxy(col/2-4, row/2-4);
    //グライダーガンを生成  
    if (key == '2') gliderGun(2, 2);
    //アプリケーションの終了
    if (key == 'q') exit();
}

//セルのクリア
void clearCell() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j].setLevel(0);
            nextCells[i][j].setLevel(0);
        }
    }
}

//ランダムに初期化する
void randomInit() {
    for (int i=1; i<col-1; i++) {
        for (int j=1; j<row-1; j++) {
            int r = (int)(random(0, 2));
            if (r==0) {
                currentCells[i][j].setLevel(0);
            }
            else {
                currentCells[i][j].setLevel(1);
            }
        }
    }
    generation = 1;
}

//更新速度、世代の情報を表示する
void dispInfo() {
    fill(255, 0, 0);
    textFont(font, 15);
    text("FPS : " + fps, 10, 15);
    text("Generation : " + generation, 10, 30);
}

//全てのセルを描画する
void drawField() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j].drawCell();
        }
    }
}

//次世代の内容を現在のセルにコピー
void updateCells() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j].setLevel(nextCells[i][j].getLevel());
        }
    }
}

//ルールに従って次世代を生成して、nextCells()に格納する
//(外周を除く部分を判定する。外周部分は常に死んでいる。)
void nextGeneration() {
    for (int i=1; i<col-1; i++) {
        for (int j=1; j<row -1; j++) {
            int level = currentCells[i][j].getLevel();
            int count = countAliveCell(i, j);

            if (level == 0) {   //セルが死んでいる時
                if (count == 3) {
                    nextCells[i][j].setLevel(1);    //セルが生まれる
                }
            }
            else {
                if (count >=4 || count <= 1) {
                    nextCells[i][j].setLevel(0);    //過密・過疎で死滅
                }
                else {
                    nextCells[i][j].setLevel(level + 1);    //生存(レベル＋１)
                }
            }
        }
    }
}

//周囲の生きているセルの数を返す
int countAliveCell(int i, int j) {
    int count = 0;

    if (currentCells[i-1][j-1].getLevel() >=1) count++;
    if (currentCells[i  ][j-1].getLevel() >=1) count++;
    if (currentCells[i+1][j-1].getLevel() >=1) count++;
    if (currentCells[i-1][j  ].getLevel() >=1) count++;
    if (currentCells[i+1][j  ].getLevel() >=1) count++;
    if (currentCells[i-1][j+1].getLevel() >=1) count++;
    if (currentCells[i  ][j+1].getLevel() >=1) count++;
    if (currentCells[i+1][j+1].getLevel() >=1) count++;

    return count;
}

//銀河を生成
void galaxy(int x, int y) {
    currentCells[x  ][y  ].setLevel(1);
    currentCells[x+1][y  ].setLevel(1);
    currentCells[x+2][y  ].setLevel(1);
    currentCells[x+3][y  ].setLevel(1);
    currentCells[x+4][y  ].setLevel(1);
    currentCells[x+5][y  ].setLevel(1);
    currentCells[x+7][y  ].setLevel(1);
    currentCells[x+8][y  ].setLevel(1);

    currentCells[x  ][y+1].setLevel(1);
    currentCells[x+1][y+1].setLevel(1);
    currentCells[x+2][y+1].setLevel(1);
    currentCells[x+3][y+1].setLevel(1);
    currentCells[x+4][y+1].setLevel(1);
    currentCells[x+5][y+1].setLevel(1);
    currentCells[x+7][y+1].setLevel(1);
    currentCells[x+8][y+1].setLevel(1);

    currentCells[x+7][y+2].setLevel(1);
    currentCells[x+8][y+2].setLevel(1);

    currentCells[x  ][y+3].setLevel(1);
    currentCells[x+1][y+3].setLevel(1);
    currentCells[x+7][y+3].setLevel(1);
    currentCells[x+8][y+3].setLevel(1);

    currentCells[x  ][y+4].setLevel(1);
    currentCells[x+1][y+4].setLevel(1);
    currentCells[x+7][y+4].setLevel(1);
    currentCells[x+8][y+4].setLevel(1);

    currentCells[x  ][y+5].setLevel(1);
    currentCells[x+1][y+5].setLevel(1);
    currentCells[x+7][y+5].setLevel(1);
    currentCells[x+8][y+5].setLevel(1);

    currentCells[x  ][y+6].setLevel(1);
    currentCells[x+1][y+6].setLevel(1);

    currentCells[x  ][y+7].setLevel(1);
    currentCells[x+1][y+7].setLevel(1);
    currentCells[x+3][y+7].setLevel(1);
    currentCells[x+4][y+7].setLevel(1);
    currentCells[x+5][y+7].setLevel(1);
    currentCells[x+6][y+7].setLevel(1);
    currentCells[x+7][y+7].setLevel(1);
    currentCells[x+8][y+7].setLevel(1);

    currentCells[x  ][y+8].setLevel(1);
    currentCells[x+1][y+8].setLevel(1);
    currentCells[x+3][y+8].setLevel(1);
    currentCells[x+4][y+8].setLevel(1);
    currentCells[x+5][y+8].setLevel(1);
    currentCells[x+6][y+8].setLevel(1);
    currentCells[x+7][y+8].setLevel(1);
    currentCells[x+8][y+8].setLevel(1);
}
//グライダーガンの生成
void gliderGun(int x, int y) {
    currentCells[x+2][y+6].setLevel(1);
    currentCells[x+2][y+7].setLevel(1);
    currentCells[x+3][y+6].setLevel(1);
    currentCells[x+3][y+7].setLevel(1);

    currentCells[x+12][y+6].setLevel(1);
    currentCells[x+12][y+7].setLevel(1);
    currentCells[x+12][y+8].setLevel(1);

    currentCells[x+13][y+5].setLevel(1);
    currentCells[x+13][y+9].setLevel(1);

    currentCells[x+14][y+4].setLevel(1);
    currentCells[x+14][y+10].setLevel(1);

    currentCells[x+15][y+4].setLevel(1);
    currentCells[x+15][y+10].setLevel(1);

    currentCells[x+16][y+7].setLevel(1);

    currentCells[x+17][y+5].setLevel(1);
    currentCells[x+17][y+9].setLevel(1);

    currentCells[x+18][y+6].setLevel(1);
    currentCells[x+18][y+7].setLevel(1);
    currentCells[x+18][y+8].setLevel(1);

    currentCells[x+19][y+7].setLevel(1);

    currentCells[x+22][y+4].setLevel(1);
    currentCells[x+22][y+5].setLevel(1);
    currentCells[x+22][y+6].setLevel(1);

    currentCells[x+23][y+4].setLevel(1);
    currentCells[x+23][y+5].setLevel(1);
    currentCells[x+23][y+6].setLevel(1);

    currentCells[x+24][y+3].setLevel(1);
    currentCells[x+24][y+7].setLevel(1);

    currentCells[x+26][y+2].setLevel(1);
    currentCells[x+26][y+3].setLevel(1);
    currentCells[x+26][y+7].setLevel(1);
    currentCells[x+26][y+8].setLevel(1);

    currentCells[x+36][y+4].setLevel(1);
    currentCells[x+36][y+5].setLevel(1);
    currentCells[x+37][y+4].setLevel(1);
    currentCells[x+37][y+5].setLevel(1);
}

