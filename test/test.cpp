
#include <gtest/gtest.h>
#include <stdlib.h>

#include <rclcpp/executor.hpp>
#include <rclcpp/rclcpp.hpp>
#include <std_msgs/msg/string.hpp>


// class TestNode : public testing::Test {
//  protected:
//   rclcpp::Node::SharedPtr node1_;
//   rclcpp::Node::SharedPtr node2_;
// };
class TestNode : public testing::TestWithParam<int> {
  // Your test fixture code here
public:
  rclcpp::Node::SharedPtr node1_;
  rclcpp::Node::SharedPtr node2_;
};

TEST_F(TestNode, test_for_publisher) {
  node1_ = std::make_shared<rclcpp::Node>("test_publisher");
  auto test_publisher =
      node1_->create_publisher<std_msgs::msg::String>("topic", 10);
  auto publishers_number = node1_->count_publishers("topic");
  EXPECT_EQ(3, static_cast<int>(publishers_number));
}

TEST_F(TestNode, test_for_subscriber) {
  node2_ = std::make_shared<rclcpp::Node>("test_subscriber");
  
  // Subscribe to the topic with a callback function
  auto subscription = node2_->create_subscription<std_msgs::msg::String>(
      "topic",
      10,
      [this](const std_msgs::msg::String::SharedPtr msg) {
        // Check if the received message is not null
        ASSERT_NE(nullptr, msg);
      });

  // Wait for a moment to allow the subscription to be established
  rclcpp::sleep_for(std::chrono::seconds(1));
}


int main(int argc, char** argv) {
  rclcpp::init(argc, argv);
  ::testing::InitGoogleTest(&argc, argv);
  int result = RUN_ALL_TESTS();
  rclcpp::shutdown();
  return result;
}