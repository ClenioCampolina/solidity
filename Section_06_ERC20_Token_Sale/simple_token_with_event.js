const enableMetaMaskButton = document.querySelector('.enableMetamask');
const statusText = document.querySelector('.statusText');
const contractAddr = document.querySelector('#address');
const listenToEventsButton = document.querySelector('.startStopEventListener');
const eventResult = document.querySelector('.eventResult')
const pastEventsButton = document.querySelector('.pastEventListener');
const pastEventResult = document.querySelector('.pastEventResult')

let accounts;
let web3;
let abi = [
	{
		"inputs": [],
		"stateMutability": "nonpayable",
		"type": "constructor"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"internalType": "address",
				"name": "_from",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"indexed": false,
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "TokensWereSent",
		"type": "event"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "_to",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "SendTokens",
		"outputs": [
			{
				"internalType": "bool",
				"name": "",
				"type": "bool"
			}
		],
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "TokenBalances",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"stateMutability": "view",
		"type": "function"
	}
]


enableMetaMaskButton.addEventListener('click', () => {enableDapp()});

listenToEventsButton.addEventListener('click', () => {listenToEvents()});

pastEventsButton.addEventListener('click', () => {listenToPastEvents()});



async function enableDapp() {
	
  if (typeof window.ethereum !== 'undefined') {
  
  	try {
    	accounts = await ethereum.request({method: 'eth_requestAccounts'});
      web3 = new Web3(window.ethereum);
      statusText.innerHTML = "Account: " + accounts[0];
      listenToEventsButton.removeAttribute("disabled");
      contractAddr.removeAttribute("disabled");
      pastEventsButton.removeAttribute("disabled");
      
    } catch (error) {
    
    	if (error.code === 4001) {
        //
        statusText.innerHTML = "Error: Need permission to access Metamask";
        console.log('Permissions needed to continue.');
        
      } else {
        console.error(error.message);
      }
    }
    
  } else {
  	statusText.innerHTML = "Error: Metamask not installed";
  }
  
}


async function listenToEvents() {
  let contractInstance = new web3.eth.Contract(abi, contractAddr.value);
  contractInstance.events.TokensWereSent().on("data", (event) => {
    eventResult.innerHTML = JSON.stringify(event) + "<br />=====<br />" + eventResult.innerHTML; 
  });
  
}

async function listenToPastEvents() {
	let anotherContractInstance = new web3.eth.Contract(abi, contractAddr.value);
  console.log("part 1");
  anotherContractInstance.getPastEvents("TokensWereSent", {FromBlock: 0, ToBlock: 'latest'}).then((event) => {
  	pastEventResult.innerHTML = JSON.stringify(event) + "<br />=====<br />" + pastEventResult.innerHTML;
	});
  console.log(JSON.stringify(event));
}


