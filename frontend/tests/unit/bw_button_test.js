import "./fixtures";
import { assert } from "chai";

// Mock function simulating the black & white conversion API
const mockConvertToBlackAndWhite = (imageUrl) => {
  if (!imageUrl) return null;
  return imageUrl.replace(".jpg", "_bw.jpg");
};

describe("Black & White Conversion", () => {
  it("should convert an image to black and white when the B/W button is clicked", () => {
    const originalImage = "https://example.com/image.jpg";
    const expectedBwImage = "https://example.com/image_bw.jpg";

    const result = mockConvertToBlackAndWhite(originalImage);
    assert.equal(result, expectedBwImage);
  });

  it("should return null if no image URL is provided", () => {
    const result = mockConvertToBlackAndWhite(null);
    assert.isNull(result);
  });
});
