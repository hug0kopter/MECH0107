import numpy as np
import matplotlib.pyplot as plt
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import RBF, ConstantKernel as C

# Generate sample data without noise
X = np.array([-3, -1.5, 0.5, 1, 2, 3]).reshape(-1, 1)
Y = (X * np.cos(X)).ravel()  # True function

# Define a kernel: constant kernel multiplied by RBF kernel
kernel = C(1.0, (1e-4, 1e1)) * RBF(1.0, (1e-4, 1e1))
gp = GaussianProcessRegressor(kernel=kernel, n_restarts_optimizer=10)

# Fit to the data using Maximum Likelihood Estimation of the parameters
gp.fit(X, Y)

# Make predictions
x_pred = np.linspace(-3, 3, 1000).reshape(-1, 1)
y_pred, sigma = gp.predict(x_pred, return_std=True)

# Plot the function, the prediction and the 95% confidence interval based on the standard deviation
plt.figure()
plt.plot(X, Y, 'b.', markersize=10, label='Observations') # Blue observation points
plt.plot(x_pred, x_pred * np.cos(x_pred), ':', color='blue',
label='True function: $f(x)=x \cos(x)$') # True function in legend
plt.plot(x_pred, y_pred, '-', color='orange', label='Prediction')
plt.fill_between(x_pred.ravel(),
    y_pred - 1.96 * sigma,
    y_pred + 1.96 * sigma,
    alpha=0.25, color='orange', label='95% confidence interval')
plt.xlabel('x')
plt.ylabel('f(x)')
plt.legend()
plt.show()