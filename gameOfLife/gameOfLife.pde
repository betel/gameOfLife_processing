static final int W_WINDOW = 301;
static final int H_WINDOW = 301;
static final int W_CELL = 20;
static final int EDIT_MODE = 0;
static final int ANIMATION_MODE = 1;
static final int FPS = 5;

Cell[][] currentCells, nextCells;

int col, row;
int mode;

void setup() {
    size(W_WINDOW, H_WINDOW);
    frameRate(FPS);	
    col = W_WINDOW / W_CELL;
    row = H_WINDOW / W_CELL;
    currentCells = new Cell[col][row];
    nextCells = new Cell[col][row];
    for (int i = 0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j] = new Cell(i*W_CELL, j*W_CELL, W_CELL);
            nextCells[i][j] = new Cell(i*W_CELL, j*W_CELL, W_CELL);
        }
    }
    mode = EDIT_MODE;
}

void draw() {
    if (mode == ANIMATION_MODE) {
        saveFrame("output-######.png");
        nextGeneration();
        updateCells();
    }
    drawField();
}

void mouseClicked() {
    if (mode == EDIT_MODE) {
        int locX = mouseX / W_CELL;
        int locY = mouseY / W_CELL;
        Cell theCell = currentCells[locX][locY];
        boolean life = theCell.getBool();

        if (life) {
            theCell.setBool(false);
        }
        else {
            theCell.setBool(true);
        }
    }
}

void keyPressed() {
    if (key == 'c') {
        clearCell();
    }
    if (key == ' ') {
        if (mode == ANIMATION_MODE) {
            mode = EDIT_MODE;
        }
        else if (mode == EDIT_MODE) {
            mode = ANIMATION_MODE;
        }
    }
    if (key == 'q') {
        exit();
    }
}

void clearCell() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j].setBool(false);
            nextCells[i][j].setBool(false);
        }
    }
}

void drawField() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j].drawCell();
        }
    }
}

void updateCells() {
    for (int i=0; i<col; i++) {
        for (int j=0; j<row; j++) {
            currentCells[i][j].setBool(nextCells[i][j].getBool());
        }
    }
}

void nextGeneration() {
    for (int i=1; i<col-1; i++) {
        for (int j=1; j<row -1; j++) {
            boolean life = currentCells[i][j].getBool();
            int count = countAliveCell(i, j);

            if (!life) {	
                if (count == 3) {
                    nextCells[i][j].setBool(true);
                }
            }
            else {
                if (count >=4 || count <= 1) {
                    nextCells[i][j].setBool(false);
                }
                else {
                    nextCells[i][j].setBool(true);
                }
            }
        }
    }
}

int countAliveCell(int i, int j) {
    int count = 0;

    if (currentCells[i-1][j-1].getBool()) count++;
    if (currentCells[i][j-1].getBool()) count++;
    if (currentCells[i+1][j-1].getBool()) count++;
    if (currentCells[i-1][j].getBool()) count++;
    if (currentCells[i+1][j].getBool()) count++;
    if (currentCells[i-1][j+1].getBool()) count++;
    if (currentCells[i][j+1].getBool()) count++;
    if (currentCells[i+1][j+1].getBool()) count++;

    return count;
}

class Cell {

    int x, y;	
    int w;	
    boolean life;

    Cell(int x, int y, int w) {
        this.x = x;
        this.y = y;
        this.w = w;
    }

    void drawCell() {
        if (life) {	
            fill(0);
        }
        else {
            fill(255);
        }

        stroke(127);	
        rect(x, y, w, w);
    }

    void setBool(boolean life) {
        this.life = life;
    }

    boolean getBool() {
        return life;
    }
}

