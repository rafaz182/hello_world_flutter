package dev.rafaz.btg_flutter_test

import android.content.Context
import android.graphics.Color
import android.graphics.drawable.ColorDrawable
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.animation.AlphaAnimation
import android.view.animation.Animation
import android.view.animation.AnimationSet
import android.widget.Button
import android.widget.ImageButton
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.DrawableCompat
import io.flutter.embedding.android.SplashScreen


class MySplashScreen : SplashScreen {

    private lateinit var splashView: View

    override fun createSplashView(context: Context, savedInstanceState: Bundle?): View? {
        Log.d("MySplashScreen", "createSplashView")
        splashView = View(context)
        splashView.background = ColorDrawable(Color.BLACK)
        return splashView
    }

    override fun transitionToFlutter(onTransitionComplete: Runnable) {
        val fadeIn: Animation = AlphaAnimation(0f, 1f)
        fadeIn.duration = 1000

        val fadeOut: Animation = AlphaAnimation(1f, 0f)
        fadeOut.startOffset = 1000
        fadeOut.duration = 1000

        val animation = AnimationSet(true)
        animation.addAnimation(fadeIn)
        animation.addAnimation(fadeOut)
        animation.setAnimationListener(object : Animation.AnimationListener{
            override fun onAnimationStart(animation: Animation?) {
            }

            override fun onAnimationEnd(animation: Animation?) {
                Log.d("MySplashScreen", "onAnimationEnd")
                onTransitionComplete.run()
                Log.d("MySplashScreen", "onTransitionComplete")
            }

            override fun onAnimationRepeat(animation: Animation?) {
            }
        })
        splashView.startAnimation(animation)

        Log.d("MySplashScreen", "transitionToFlutter")
        //onTransitionComplete.run()
    }
}