pragma solidity ^0.5.0;

contract SocialNetwork{
	string public name;
	uint public postCount=0;
	mapping(uint => Post)public posts;

	struct Post{
	uint id;
	string content;
	uint tipAmount;
	address payable author;
	}

	event PostCreated(
		uint id,
		string content,
		uint tipAmount,
		address payable author
	);
	event PostTipped(
		uint id,
		string content,
		uint tipAmount,
		address payable author
	);

	constructor() public{
	name="Dapp University social network";
	}

	function createPost(string memory _content) public{
	//require valid content
	require(bytes(_content).length > 0);
		//increment the post count
		postCount++;

		//create the post
	posts[postCount]=Post(postCount,_content,0,msg.sender);
	//trigger event
	emit PostCreated(postCount,_content,0,msg.sender);
	}

    function tipPost(uint _id) public payable {
        // Make sure the id is valid
        require(_id > 0 && _id <= postCount);
        // Fetch the post
        Post memory _post = posts[_id];
        // Fetch the author
        address payable _author = _post.author;
        // Pay the author by sending them Ether
        address(_author).transfer(msg.value);
        // Incremet the tip amount
        _post.tipAmount = _post.tipAmount + msg.value;
        // Update the post
        posts[_id] = _post;
        // Trigger an event
        emit PostTipped(postCount, _post.content, _post.tipAmount, _author);
    }

}