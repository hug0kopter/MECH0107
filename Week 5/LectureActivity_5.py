import numpy as np
import matplotlib.pyplot as plt
from pyDOE import lhs

# Latin Hypercube Sampling (LHS)

# Define parameters
n_samples = 10  # Number of samples

# Generate LHS samples using pyDOE
lhs_samples = lhs(2, samples=n_samples, criterion='maximin')

# Plot the samples (only for 2D case)
plt.scatter(lhs_samples[:, 0], lhs_samples[:, 1], color='blue', label="LHS Samples")
plt.xlabel("Feature 1")
plt.ylabel("Feature 2")
plt.xlim(0, 1)
plt.ylim(0, 1)

# Add interval lines for visualization
for i in range(1, n_samples + 1):
    plt.axvline(x=(i / n_samples), color='gray', linestyle='--', linewidth=0.5)
    plt.axhline(y=(i / n_samples), color='gray', linestyle='--', linewidth=0.5)

plt.show()

# Print generated samples
print("LHS Samples:\n", lhs_samples)
