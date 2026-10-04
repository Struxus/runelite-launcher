package net.runelite.launcher;

import java.awt.Image;
import java.awt.image.BaseMultiResolutionImage;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;

/** Native-sized window icons and a 200-logical-pixel HiDPI splash. */
final class Branding
{
    private Branding() {}

    static List<Image> icons() throws IOException
    {
        List<Image> images = new ArrayList<>();
        for (int size : new int[]{16, 20, 24, 32, 40, 48, 64, 96, 128, 256})
        {
            images.add(read("runelite_" + size + ".png"));
        }
        return images;
    }

    static ImageIcon splash() throws IOException
    {
        return new ImageIcon(new BaseMultiResolutionImage(
            read("runelite_splash.png"),
            read("runelite_splash@2x.png"),
            read("runelite_splash@3x.png")));
    }

    private static Image read(String name) throws IOException
    {
        try (var stream = Branding.class.getResourceAsStream(name))
        {
            if (stream == null) throw new IOException("Missing launcher artwork: " + name);
            var image = ImageIO.read(stream);
            if (image == null) throw new IOException("Invalid launcher artwork: " + name);
            return image;
        }
    }
}
