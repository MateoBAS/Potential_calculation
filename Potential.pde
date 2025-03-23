// Main configuration
final float CELL_SIZE = 4;
final int BRUSH_SIZE = 11; // Odd number
final int CALC_SPEED = 100;
final int POTENTIAL_RANGE = 250;

// Interactive areas
final float[] GRID_AREA = {200, 100, 1200, 700};
final float[] BTN_CALC = {50, 400, 120, 50};
final float[] BTN_INPUT = {50, 475, 120, 50};

// Main class
ElectricSimulator simulator;

void setup() {
  size(1500, 900);
  colorMode(HSB, 360);
  simulator = new ElectricSimulator();
}

void draw() {
  background(20);
  simulator.update();
  simulator.display();
}

void mousePressed() {
  simulator.handleMousePress();
}

void mouseDragged() {
  simulator.handleMouseDrag();
}

void keyPressed() {
  simulator.handleKeyPress();
}

class ElectricSimulator {
  Grid grid;
  UIButton calcButton;
  UIButton inputButton;
  String userInput = "";
  float currentVoltage = 0;
  boolean calculating = false;
  boolean voltageSubmitted = false;
  
  ElectricSimulator() {
    int rows = int(GRID_AREA[3]/CELL_SIZE);
    int cols = int(GRID_AREA[2]/CELL_SIZE);
    
    grid = new Grid(GRID_AREA[0], GRID_AREA[1], 
                   GRID_AREA[2], GRID_AREA[3], 
                   rows, cols);
                   
    calcButton = new UIButton(BTN_CALC[0], BTN_CALC[1], 
                             BTN_CALC[2], BTN_CALC[3], 
                             "Calculate");
                             
    inputButton = new UIButton(BTN_INPUT[0], BTN_INPUT[1], 
                              BTN_INPUT[2], BTN_INPUT[3], 
                              "");
  }
  
  void update() {
    if (calculating) {
      grid.calculatePotentials(CALC_SPEED);
    }
  }
  
  void display() {
    grid.display();
    calcButton.display();
    String displayText = userInput.isEmpty() ? str(currentVoltage) : userInput;
    inputButton.display(displayText, voltageSubmitted);
  }
  
  void handleMousePress() {
    if (calcButton.isHovered()) {
      calculating = !calculating;
    } else {
      grid.applyVoltage(mouseX, mouseY, BRUSH_SIZE, currentVoltage);
    }
  }
  
  void handleMouseDrag() {
    if (!calcButton.isHovered()) {
      grid.applyVoltage(mouseX, mouseY, BRUSH_SIZE, currentVoltage);
    }
  }
  
  void handleKeyPress() {
    if (key == ENTER) {
      submitVoltage();
    } else if (key == BACKSPACE) {
      deleteLastChar();
    } else if (key == '-') {
      addNegativeSign();
    } else if (Character.isDigit(key) || key == '.') {
      addInputChar();
    } else if (key == 'm') {
      grid.printMiddleSection();
    }
  }
  
  private void submitVoltage() {
    if (!userInput.isEmpty()) {
      currentVoltage = float(userInput);
      userInput = "";
      voltageSubmitted = true;
    }
  }
  
  private void deleteLastChar() {
    if (!userInput.isEmpty()) {
      userInput = userInput.substring(0, userInput.length()-1);
      voltageSubmitted = false;
    }
  }
  
  private void addNegativeSign() {
    if (userInput.isEmpty()) {
      userInput += "-";
      voltageSubmitted = false;
    }
  }
  
  private void addInputChar() {
    userInput += key;
    voltageSubmitted = false;
  }
}

class Grid {
  float x, y, w, h;
  int rows, cols;
  float[][] potentials;
  boolean[][] fixedCells;
  
  Grid(float x, float y, float w, float h, int rows, int cols) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.rows = rows;
    this.cols = cols;
    initGrid();
  }
  
  private void initGrid() {
    potentials = new float[rows][cols];
    fixedCells = new boolean[rows][cols];
  }
  
  void display() {
    noStroke();
    for (int i = 0; i < cols; i++) {
      for (int j = 0; j < rows; j++) {
        drawCell(i, j);
      }
    }
  }
  
  private void drawCell(int i, int j) {
    if (potentials[j][i] != 0) {
      float hue = map(potentials[j][i], -POTENTIAL_RANGE, POTENTIAL_RANGE, 270, 0);
      fill(hue, 360, 360);
    } else {
      fill(45);
    }
    rect(x + i * (w/cols), y + j * (h/rows), w/cols, h/rows);
  }
  
  void applyVoltage(float mx, float my, int brushSize, float voltage) {
    if (mx > x && mx < x + w && my > y && my < y + h) {
      int gridX = (int)((mx - x) / (w/cols));
      int gridY = (int)((my - y) / (h/rows));
      
      for (int i = -brushSize/2; i <= brushSize/2; i++) {
        for (int j = -brushSize/2; j <= brushSize/2; j++) {
          setCell(gridY + i, gridX + j, voltage);
        }
      }
    }
  }
  
  private void setCell(int row, int col, float voltage) {
    if (row >= 0 && row < rows && col >= 0 && col < cols) {
      potentials[row][col] = voltage;
      fixedCells[row][col] = true;
    }
  }
  
  void calculatePotentials(int iterations) {
    for (int k = 0; k < iterations; k++) {
      for (int i = 1; i < cols - 1; i++) {
        for (int j = 1; j < rows - 1; j++) {
          if (!fixedCells[j][i]) {
            potentials[j][i] = (potentials[j-1][i] + potentials[j+1][i] 
                               + potentials[j][i-1] + potentials[j][i+1])/4;
          }
        }
      }
    }
  }
  
  void printMiddleSection() {
    for (int i = 0; i < (2*5 + 95)/CELL_SIZE; i++) {
      println("[", i-5, "] ", potentials[rows/2][cols/3 + i]);
    }
  }
}

class UIButton {
  float x, y, w, h;
  String label;
  
  UIButton(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void display() {
    display("", false);
  }
  
  void display(String value, boolean submitted) {
    // Draw button background
    fill(45);
    stroke(submitted ? 255 : 45);
    strokeWeight(2);
    rect(x, y, w, h, 5);
    
    // Draw text
    fill(360);
    textSize(20);
    textAlign(CENTER, CENTER);
    String displayText = value.isEmpty() ? label : value;
    text(displayText, x + w/2, y + h/2);
  }
  
  boolean isHovered() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}
