from robot.libraries.BuiltIn import BuiltIn
import base64
import datetime
import os
import time


def capture_full_page_screenshot_keyword():
    """
    Captures a full-page screenshot using Chrome DevTools Protocol (CDP)
    and saves it as a PNG file in a directory determined by the environment.
    Handles lazy-loaded content by scrolling through the page.
    """
    # Get the instance of SeleniumLibrary
    selib = BuiltIn().get_library_instance("SeleniumLibrary")

    # Wait for the page to load fully
    selib.driver.implicitly_wait(10)  # Implicit wait for 10 seconds

    # Ensure the page is fully loaded before proceeding
    time.sleep(5)

    # Scroll until the bottom of the page
    last_height = selib.driver.execute_script("return document.body.scrollHeight")

    while True:
        # Scroll down to the bottom of the page
        selib.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

        # Wait for new content to load (adjust the sleep time if necessary)
        time.sleep(3)

        # Check new scroll height and compare it with the last scroll height
        new_height = selib.driver.execute_script("return document.body.scrollHeight")

        # If the height hasn't changed, we have reached the bottom
        if new_height == last_height:
            break
        last_height = new_height

    # Create screenshot directory if it doesn't exist
    screenshot_dir = BuiltIn().get_variable_value("${SCREENSHOT_DIR}")
    if not os.path.exists(screenshot_dir):
        os.makedirs(screenshot_dir)

    # Create a filename using the dashboard name and date
    date = datetime.datetime.now().strftime("%d%m%Y")
    dashboard_name = BuiltIn().get_variable_value("${DASHBOARD_NAME}")
    filename = f"{screenshot_dir}/{dashboard_name}_{date}.png"

    # Execute the CDP command to capture a full-page screenshot
    params = {"captureBeyondViewport": True}
    result = selib.driver.execute_cdp_cmd("Page.captureScreenshot", params)

    # Decode base64 data and save it as a file
    with open(filename, "wb") as file:
        file.write(base64.b64decode(result["data"]))

    # Log and return the file path
    BuiltIn().log(f"Full-page screenshot saved at {filename}")
    return filename
