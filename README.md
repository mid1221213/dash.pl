# dash.pl - Perl implementation of Amazon Dash Button detection

I have made a Perl port of the node.js implementation of the Amazon Dash Button detector and I wanted to share it with other who may prefer, like me, to use perl.

The original node.js implementation I used is available [there](https://github.com/hortinstein/node-dash-button) (GitHub).

Here is a copy of the button configuration text to prepare the dash buttons, from the link above:

### First Time Dash Button Setup

Follow Amazon's instructions to configure your button to send messages when you push them but not actually order anything. When you get a Dash button, Amazon gives you a list of setup instructions to get going. Just follow this list of instructions, but don’t complete the final step (#3 I think) **Do not select a product, just exit the app**.

### Installing prerequisites

#### Debian / Ubuntu

``` sh
$ sudo apt-get install libnet-pcap-perl libnet-frame-perl libpcap-dev
```
#### RedHat / Fedora

**?**

If somebody knows what are the prerequisites, please tell me :-)

### Configuration of dash.pl

At the beginning of the file `dash.pl` (which contains everything that is needed), there is a configuration section. This section is filled with an example that is, actually, my setup (with dummy actions). You need to adapt it to your needs.

Change the line which reads:

``` perl
my $dev = 'eth1';
```

to match the device on which you want to listen.

Then, below in the script, you can see an array containing 2 structures (hash references). Each structure contains the hardware address (a.k.a. Ethernet address, MAC address) `hwaddr`, the `name` (used only for display) and the `action` to do when the button is pushed.

The first time you only need to configure the device because you don't already know the MAC addresses.

Once done, do this:

``` sh
$ sudo ./dash.pl
```

then press your button, wait for 2 ou 3 seconds, and you will see a message saying a button has been detected with its MAC address.

You then just have to fill the structure above with the correct information, and choose the action.

**BEWARE:** the action is executed by `root`!!! Keep this in mind. You may need to release priviledges in your script (if you use a script) to be safer.

### Using dash.pl

Well... Once you have done all steps above, that's it! Just launch again the script and enjoy!

### Installing dash.pl as a systemd service

After configuring dash.pl, you may want to use it as a service to be automatically started as a daemon when your computer is switched on.

Edit the file `dash.service` to modify the path to the file `dash.pl`, then use the following command to edit the new service:

``` sh
$ sudo systemctl edit --force dash.service
```

In the editor opened by this command, copy / paste the content of your `dash.service` modified file. Then save the file and quit the editor. Then:

``` sh
$ sudo systemctl enable dash.service
$ sudo systemctl start dash.service
```
