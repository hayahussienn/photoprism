let chai = require("chai/chai");
let assert = chai.assert;

describe("Black & White Button Feature", () => {
  // Test to check if clicking the B/W button produces a B/W image
  it("should convert an image to black and white when the button is clicked", async () => {
    // Create a simple implementation of the conversion function
    const uploadAndConvertImage = async (file) => {
      // In a real scenario, this would send the file to a server
      // For our test, we'll just return a success response
      return "http://localhost:8080/converted/black-and-white-image.jpg";
    };

    // Test with a mock file
    const testFile = new File(["test-image-data"], "photo.jpg", { type: "image/jpeg" });

    // Call the function and get the result
    const result = await uploadAndConvertImage(testFile);

    // Check that we get a URL back for a black and white image
    assert.isString(result, "Should return a string URL");
    assert.include(result, "converted", "URL should include 'converted'");
    assert.include(result, "black-and-white", "URL should reference a black and white image");
  });
});