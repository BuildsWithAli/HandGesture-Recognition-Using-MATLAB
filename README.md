#     Hand Gesture Recognition System
A high-performance computer vision application developed in MATLAB that identifies hand gestures in real-time. This system utilizes advanced image processing techniques to translate physical movements into digital commands.

# 🚀 Overview
This project provides a robust solution for gesture classification. The system is designed with dual-input functionality:

-> Live Mode: Processes real-time feed from a connected webcam.

-Static Mode: Performs analysis on pre-captured input images stored in the system.

The pipeline utilizes skin segmentation, morphological noise reduction, and convexity hull algorithms to accurately recognize and classify hand gestures regardless of the input source.

# 🛠 Technologies & Techniques
-> Platform: MATLAB

-> Core Concepts:

Skin Masking: Thresholding in color spaces to isolate the hand region.

Morphological Operations: Erosion, dilation, and closing to filter noise.

Convexity Hull Analysis: Determining the geometry of the hand to count fingers and detect gestures.

Real-time Processing: Optimized webcam integration for low-latency feedback.

# 📂 Repository Structure
/src: Contains the primary MATLAB scripts (.m files) and GUI interfaces.

/docs: Project report and presentation slides (PPT).

/assets: Sample images and diagrams showing the segmentation process.

# 🎬 Demo
[![Watch the Demo](https://img.youtube.com/vi/QVt9dW78i60/0.jpg)](https://www.youtube.com/watch?v=QVt9dW78i60)
*(Click the image above to watch the full project demo on YouTube)*


# 👨‍💻 Project Details
Student: Ali Hamza

Academic Registration: FA23-BCE-012

Institution: COMSATS University Islamabad, Lahore Campus
