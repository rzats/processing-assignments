////////////////////////////////////////////////////
///                                              ///
///              Global constants                ///
///                                              ///
////////////////////////////////////////////////////

//The number of parts by which each line is divided in drawLines()
int divisionCount = 1;

//The maximum possible amount of parts by which each line can be divided
//100 is the recommended maximum
int maxDivisionCount = 100;

//The value that determines division changing speed
int divisionSpeedMultiplier = 1;

//The value used in cyclical divisionCount changes
boolean changingUp = true;

//The radius of the circle determining the location of the star's inner and outer vertices respectively
float radius1 = 100;
float radius2 = 200; 

//The relation between radius2 and radius1 - calculated at compile-time to prevent sizing issues
float radiusRel = radius2 / radius1;

//The initial angle offset of the star's first vertice
float initialAngle = (55) * TWO_PI / 360;

//The smallest possible values for radius1 and radius2 respectively
float minInnerRadius = 10;
float maxOuterRadius = 300;

//The font object used for rendering on-screen instructions
PFont f;

////////////////////////////////////////////////////
///                                              ///
///       Setup & main drawing functions         ///
///                                              ///
////////////////////////////////////////////////////

//Set the canvas size to 800x600 (no scalability for now)
void setup()
{
  size (800, 600);  
  f = createFont("Consolas", 13, true);
}

//Main drawing function
void draw()
{
  //Clear the frame so that the star is constantly redrawn
  //(also set the background color to white and the window title to a custom value)
  background(255); 
  drawStar(initialAngle, radius1, radius2, divisionCount);
  surface.setTitle("Drawing Assignment");

  //Draw control instructions
  textFont(f, 13);
  fill(0);
  text("CONTROLS:"
    + "\r\nW/S, UP/DOWN or LMB/RMB to change the division number"
    + "\r\nA/D or Left/Right to rotate"
    + "\r\nMousewheel to resize"
    + "\r\n(Hold) C to cycle divisions", 20, 30);

  //Draw technical/debugging stuff
  text("radius1            " + radius1
    +"\r\nradius2            " + radius2
    +"\r\nDivision count     " + divisionCount
    +"\r\n                   (max: " + maxDivisionCount + ")"
    +"\r\nCycling up?        " + changingUp, 590, 500);
}

//Draws the star polygon

void drawStar(float init, float rad1, float rad2, int n)
{
  float angle = TWO_PI / 5;
  float halfAngle = angle / 2.0;

  for (float i = 0; i < TWO_PI; i += angle)
  {
    //Define the first vertex
    float x1 = 400 + cos(init + i - halfAngle) * rad1;
    float y1 = 300 + sin(init + i - halfAngle) * rad1;
    //Define the second vertex
    float x2 = 400 + cos(init + i) * rad2;
    float y2 = 300 + sin(init + i) * rad2;
    //Define the third vertex
    float x3 = 400 + cos(init + i + halfAngle) * rad1;
    float y3 = 300 + sin(init + i + halfAngle) * rad1;

    drawLines(x1, y1, x2, y2, x3, y3, n);
  }
}

//Gets a color from a preset list

color getColorById(float id)
{
  if (id == 1)
  {
    return color (255, 0, 0);
  } else if (id == 2)
  {
    return color (255, 255, 0);
  } else if (id == 3)
  {
    return color (0, 255, 0);
  } else //id == 0
  {
    return color(0, 0, 255);
  }
}

//Given three vertices, draws them and a pattern described in the assignment.

void drawLines(float x1, float y1, float x2, float y2, float x3, float y3, int n)
{
  //Draw the pattern
  for (float i = 1; i < n; i++)
  {
    stroke(getColorById(i % 4));
    line
      (
      x1 + (i / n) * (x2 - x1), 
      y1 + (i / n) * (y2 - y1), 
      x2 + (i / n) * (x3 - x2), 
      y2 + (i / n) * (y3 - y2)
      );
  }

  color black = color(0, 0, 0);
  stroke(black);

  //Draw the initial angle
  //done after the pattern to avoid awkward overlapping

  line (x1, y1, x2, y2);
  line (x2, y2, x3, y3);
}

////////////////////////////////////////////////////
///                                              ///
///       Misc. interactivity features           ///
///                                              ///
////////////////////////////////////////////////////

void mouseClicked()
{
  //Increase the division count on LMB
  if (mouseButton == LEFT)
  {
    if (divisionCount < maxDivisionCount)
    {
      divisionCount += divisionSpeedMultiplier;
    }
  }
  //Decrease it on LMB
  else if (mouseButton == RIGHT)
  {
    if (divisionCount > 1)
    {
      divisionCount -= divisionSpeedMultiplier;
    }
  }
}

void mouseWheel(MouseEvent event)
{
  //Change the star's radius
  //Note: event.getCount() > 0 stands for MWHEELDOWN, <0 for MWHEELUP
  if ((event.getCount() > 0 && radius1 > minInnerRadius) || (event.getCount() < 0 && radius2 < maxOuterRadius))
  {
    radius1 -= event.getCount();
    radius2 -= event.getCount() * radiusRel;
  }
}

void keyPressed()
{
  //Increase the division count on W or Up arrow
  if (key == 'w' || keyCode == UP)
  {
    if (divisionCount < maxDivisionCount)
    {
      divisionCount += divisionSpeedMultiplier;
    }
  }
  //Decrease it on S or Down arrow
  else if (key == 's' || keyCode == DOWN)
  {
    if (divisionCount > 1)
    {
      divisionCount -= divisionSpeedMultiplier;
    }
  }
  //Cycle the division count value
  else if (key == 'c')
  {
    if (changingUp)
    {
      if (divisionCount < maxDivisionCount)
      {
        divisionCount += divisionSpeedMultiplier;
      } else
      {
        divisionCount -= divisionSpeedMultiplier;
        changingUp = false;
      }
    } else
    {
      if (divisionCount > 1)
      {
        divisionCount -= divisionSpeedMultiplier;
      } else
      {
        divisionCount += divisionSpeedMultiplier;
        changingUp = true;
      }
    }
  }
  //Rotate the star counterclockwise on A or Left arrow
  else if (key == 'a' || keyCode == LEFT)
  {
    initialAngle -= TWO_PI / 180;
  }
  //Rotate it clockwise on D or Right arrow
  else if (key == 'd' || keyCode == RIGHT)
  {
    initialAngle += TWO_PI / 180;
  }
}