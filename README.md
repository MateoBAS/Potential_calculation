# Electric Potential Simulator

![Demo of the electric potential simulator](example.gif)

## Description
This project is an interactive electric potential simulator built using Processing. It allows users to visualize and calculate electric potential distributions in a 2D grid. Users can:

- Input specific voltage values
- Set electric potentials by clicking and dragging on the grid
- Calculate potential distributions using a numerical method (Gauss–Seidel method)
- Visualize the results with a color-coded heatmap

The simulation is particularly useful for understanding basic principles of electrostatics and numerical methods in physics.

## Features
- Interactive grid for setting potentials
- Real-time visualization of electric potential
- Customizable brush size for setting voltages
- Support for positive and negative voltages
- Numerical calculation of potential distribution
- Middle-section potential profile visualization

## How to Use
1. **Input Voltage**: Type the desired voltage (positive or negative) and press Enter.
2. **Draw Voltages**: Click and drag on the grid to set voltages.
3. **Calculate**: Click the "CALCULATE" button to compute the potential distribution.
4. **Visualize**: The grid will show the potential distribution using a color gradient.
5. **Profile**: Press 'm' to print the potential profile along the middle section.

## Installation
1. Download and install [Processing](https://processing.org/download/).
2. Clone this repository:
   ```bash
   git clone https://github.com/tu-usuario/potential_calculation.git
3. Open the .pde file in Processing.
4. Run the sketch

## Numerical method
The electric potential distribution is calculated using the Relaxation Method (Gauss–Seidel method) [1], an iterative numerical technique for solving Laplace's equation. 

## License
This project is licensed under the MIT License.

## References
-Thijssen, J. (2007). *Computational Physics* (2nd ed.). Cambridge University Press.  
 *Appendix A7.2: Partial differential equations, (pp. 578-590).
