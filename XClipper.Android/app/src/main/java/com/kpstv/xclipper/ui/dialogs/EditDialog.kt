package com.kpstv.xclipper.ui.dialogs

import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.recyclerview.widget.StaggeredGridLayoutManager
import com.kpstv.license.Decrypt
import com.kpstv.license.Encrypt
import com.kpstv.xclipper.App
import com.kpstv.xclipper.App.STAGGERED_SPAN_COUNT
import com.kpstv.xclipper.App.STAGGERED_SPAN_COUNT_MIN
import com.kpstv.xclipper.R
import com.kpstv.xclipper.data.model.Clip
import com.kpstv.xclipper.extensions.Coroutines
import com.kpstv.xclipper.extensions.clone
import com.kpstv.xclipper.extensions.listeners.RepositoryListener
import com.kpstv.xclipper.extensions.utils.ThemeUtils
import com.kpstv.xclipper.ui.adapters.EditAdapter
import com.kpstv.xclipper.ui.viewmodels.MainViewModel
import com.kpstv.xclipper.ui.viewmodels.MainViewModelFactory
import es.dmoral.toasty.Toasty
import kotlinx.android.synthetic.main.dialog_edit_layout.*
import kotlinx.coroutines.delay
import org.kodein.di.KodeinAware
import org.kodein.di.android.kodein
import org.kodein.di.generic.instance

class EditDialog : AppCompatActivity(), KodeinAware {
    override val kodein by kodein()
    private val viewModelFactory by instance<MainViewModelFactory>()

    private var spanCount = 2

    private lateinit var clip: Clip
    private lateinit var adapter: EditAdapter
    private lateinit var edType: EDType
    private val mainViewModel: MainViewModel by lazy {
        ViewModelProvider(this, viewModelFactory).get(MainViewModel::class.java)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        ThemeUtils.setDialogTheme(this)

        setContentView(R.layout.dialog_edit_layout)

        toolbar.navigationIcon = getDrawable(R.drawable.ic_close)
        toolbar.setNavigationOnClickListener {
            finish()
        }

        setRecyclerView()

        edType = if (mainViewModel.editManager.getClip() == null) EDType.Create
        else {

            /** Set the current clip for managing */
            clip = mainViewModel.editManager.getClip()!!

            de_editText.setText(clip.data)
            EDType.Edit
        }
    }

    override fun onPostCreate(savedInstanceState: Bundle?) {
        super.onPostCreate(savedInstanceState)

        /** A Timeout on binding creates a cool effect */

        Coroutines.main {
            delay(App.DELAY_SPAN)
            bindUI()
        }
    }

    fun saveClick(view: View) {
        val text = de_editText.text.toString()

        if (text.isNotBlank()) {
            if (edType == EDType.Edit) {
                performEditTask(text)
            } else {
                performCreateTask(text)
            }
        } else
            Toasty.error(this, getString(R.string.error_empty_text)).show()
    }

    private fun performEditTask(text: String) {
        mainViewModel.checkForDuplicateClip(text, clip.id!!, RepositoryListener(
            dataExist = Toasty.error(
                this,
                getString(R.string.error_duplicate_data)
            )::show,
            notFound = {
                mainViewModel.postUpdateToRepository(
                    clip,
                    /** In the second parameter we are also supplying the tags as well. */
                    clip.clone(text.Encrypt(), mainViewModel.editManager.getSelectedTags())
                )
                postSuccess()
            }
        ))
    }

    private fun performCreateTask(text: String) {
        mainViewModel.checkForDuplicateClip(text,
            RepositoryListener(
                dataExist = Toasty.error(
                    this,
                    getString(R.string.error_duplicate_data)
                )::show,
                notFound = {
                    mainViewModel.postToRepository(
                        Clip.from(text, mainViewModel.editManager.getSelectedTags())
                    )
                    postSuccess()
                }
            ))
    }

    private fun postSuccess() {
        Toasty.info(this, getString(R.string.edit_success)).show()
        finish()
    }

    private fun setRecyclerView() {
        adapter = EditAdapter(
            viewLifecycleOwner = this,
            selectedTags = mainViewModel.editManager.selectedTags,
            onClick = { tag, _ ->
                mainViewModel.editManager.addOrRemoveSelectedTag(tag)
            }
        )

        refreshRecyclerView(spanCount)

        del_recyclerView.adapter = adapter
    }

    private fun bindUI() {

        mainViewModel.editManager.spanCount.observe(this, Observer {
            refreshRecyclerView(it)
        })

        mainViewModel.editManager.tagFixedLiveData.observe(this, Observer {
            if (it.size > 3)
                mainViewModel.editManager.postSpanCount(STAGGERED_SPAN_COUNT)
            else
                mainViewModel.editManager.postSpanCount(STAGGERED_SPAN_COUNT_MIN)
            adapter.submitList(it)
        })
    }

    private fun refreshRecyclerView(span: Int) {
        del_recyclerView.layoutManager =
            StaggeredGridLayoutManager(span, StaggeredGridLayoutManager.HORIZONTAL)
    }



    override fun onDestroy() {
        super.onDestroy()
        mainViewModel.editManager.clearClip()
    }


    enum class EDType {
        Create,
        Edit
    }


}