import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

# Define parameters
n_samples = 10  # Number of samples

# Input matrix
X = np.random.rand(n_samples, 2)  # Random sampling

# Modify input matrix
lower_bounds = np.array([4, 0])  # Define lower bounds for each dimension
upper_bounds = np.array([10, 5])  # Define upper bounds for each dimension
X = X * (upper_bounds - lower_bounds) + lower_bounds
X1 = X[:, 0].reshape(-1, 1)
X2 = X[:, 1].reshape(-1, 1)

# Generate target variable (example linear relationship)
Y = 5 + 2 * X1 + 3 * X2 + np.random.randn(n_samples, 1)

# Fit the multiple linear regression model
model = LinearRegression()
model.fit(X, Y)

# Calculate R² score
r_squared = model.score(X, Y)
print(f"R² (coefficient of determination): {r_squared:.4f}")

# Predict on a new data point
X_pred = np.array([[7, 3]])  # Ensure it's a 2D array
y_pred = model.predict(X_pred)
print(f"Predicted value for input {X_pred.flatten().tolist()} is: {y_pred.item():.4f}")

# Generate a grid for the surface plot
X1_range = np.linspace(X[:, 0].min(), X[:, 0].max(), 20)
X2_range = np.linspace(X[:, 1].min(), X[:, 1].max(), 20)
X1_grid, X2_grid = np.meshgrid(X1_range, X2_range)
Y_grid = model.intercept_[0] + model.coef_[0, 0] * X1_grid + model.coef_[0, 1] * X2_grid

# Plot the results
fig = plt.figure(figsize=(10, 6))
ax = fig.add_subplot(111, projection='3d', computed_zorder=False)

# Surface plot of the regression plane
ax.plot_surface(X1_grid, X2_grid, Y_grid, alpha=0.5, cmap='jet')

# Scatter plot of the original data
ax.scatter(X1, X2, Y, color='blue')

# Labels
ax.set_xlabel('Feature 1')
ax.set_ylabel('Feature 2')
ax.set_zlabel('Target Variable')
plt.show()
